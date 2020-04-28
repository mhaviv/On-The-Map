//
//  LoginViewController.swift
//  On The Map
//
//  Created by Michael Haviv on 11/9/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var gmailLoginButton: UIButton!
    @IBOutlet weak var dontHaveAnAccountLabel: UILabel!
    
    var session: SessionResponse!
    
    let sharedTabBarViewInstance = TabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        udacityLogoStyling()
        facebookButtonStyling()
        gmailButtonStyling()
        
        
        dontHaveAnAccountLabel.adjustsFontSizeToFitWidth = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hasSession = (getUserSession() != nil)
        if hasSession {
            navigateToHome()
        }
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeToKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        view.endEditing(true)
        enableViews(false)
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if email.isEmpty || password.isEmpty {
            displayAlert(title: "Login Unsuccessful", message: "Username or Password is empty")
            enableViews(true)
        } else {
            authenticateUser(email: email, password: password)
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        /* Open Udacity Sign Up URL */
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated") {
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .cancelled:
                print("Facebook login cancelled")
                break
            case .failed(let error):
                print("Facebook login failed: \(error.localizedDescription)")
                break
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Access token == \(accessToken)")
                
                self.loginComplete(session: Session(expiration: accessToken.expirationDate, provider: .facebook))
            }
        }
    }
    
    @IBAction func loginWithGmail(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Helpers
    
    func displayAlert(title: String, message: String?) {
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleAuthenticationError(_ error: Error) {
        let message: String = {
            if let errorCode = (error as NSError?)?.code, errorCode == 403 {
                return "Invalid Username and/or Password"
            }
            return "\(error.localizedDescription)"
        }()
        displayAlert(title: "Login Unsuccessful", message: message)
        enableViews(true)
    }
    
    private func handleAuthenticationResponse(_ response: SessionResponse?, error: Error?) {
        if let sessionResponse = response {
            session = sessionResponse
            loginComplete(session: Session(response: sessionResponse))
            print("Login Successful!")
        } else if let error = error {
            handleAuthenticationError(error)
        }
    }
    
    private func authenticateUser(email: String, password: String) {
        UdacityClient.sharedInstance().AuthenticateUser(username: email, password: password) { [weak self] (response, error) in
            self?.handleAuthenticationResponse(response, error: error)
        }
    }
    
    private func navigateToHome() {
        if let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeTab") as? TabBarViewController {
            UIApplication.shared.windows.first?.rootViewController = tabBarController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func loginComplete(session: Session) {
        // Make Tab Bar Controller root controller on successful login
        navigateToHome()
        enableViews(true)
//        saveUserSession(session)
    }
    
//    private func saveUserSession(_ session: Session) {
//        //TODO: Why Session can't be stored in UserDefaults
//        //UserDefaults.standard.set(session, forKey: Constants.UserDefaults.userSession)
//        //TODO: utilize set bool to keep the user logged in
//        UserDefaults.standard.set(<#T##value: Bool##Bool#>, forKey: <#T##String#>)
//        UserDefaults.standard.synchronize()
//    }
    
    private func getUserSession() -> Session? {
        return UserDefaults.standard.object(forKey: Constants.UserDefaults.userSession) as? Session
    }
    
    
    /// Enables or disables the views to display the loading state.
    private func enableViews(_ isEnabled: Bool) {
        if isEnabled == true {
            Spinner.stop()
        } else {
            Spinner.start()
        }
    }
    
    func udacityLogoStyling() {
        let imageViewWidthConstraint = NSLayoutConstraint(item: udacityLogo!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        let imageViewHeightConstraint = NSLayoutConstraint(item: udacityLogo!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        udacityLogo.addConstraints([imageViewWidthConstraint, imageViewHeightConstraint])
    }
    
    func facebookButtonStyling() {
        let facebookLogo = UIImage(named: "facebookLogo.png")
        facebookLoginButton.setTitle("Sign in with Facebook", for: .normal)
        facebookLoginButton.setImage(facebookLogo, for: .normal)
        facebookLoginButton.semanticContentAttribute = .forceLeftToRight
        facebookLoginButton.setTitleColor(.white, for: .normal)
        facebookLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginButton.imageView?.contentMode = .scaleAspectFit
        facebookLoginButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 5, right: 200)
        facebookLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        facebookLoginButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        facebookLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        facebookLoginButton.layer.cornerRadius = 5
    }
    
    
    //TODO: create a GoogleButton which inherits UIButton and move styling logic in func awakeFromNib()
    func gmailButtonStyling() {
        let gmailLogo = UIImage(named: "googleLogo.png")
        gmailLoginButton.setTitle("Sign in with Gmail", for: .normal)
        gmailLoginButton.setImage(gmailLogo, for: .normal)
        gmailLoginButton.semanticContentAttribute = .forceLeftToRight
        gmailLoginButton.setTitleColor(.white, for: .normal)
        gmailLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        gmailLoginButton.imageView?.contentMode = .scaleAspectFit
        gmailLoginButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 192)
        gmailLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        gmailLoginButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        self.gmailLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        gmailLoginButton.imageView?.widthAnchor.constraint(equalTo: facebookLoginButton.imageView!.widthAnchor, multiplier: 1.0).isActive = true
        gmailLoginButton.imageView?.heightAnchor.constraint(equalTo: facebookLoginButton.imageView!.heightAnchor, multiplier: 1.0).isActive = true
        
        gmailLoginButton.layer.cornerRadius = 5
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -(getKeyboardHeight(notification))
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//TODO: Move styling here
class GoogleButton: SocialButton {
    
}

class SocialButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    private func setupStyle() {
        
    }
}
