//
//  Spinner.swift
//  On The Map
//
//  Created by Michael Haviv on 2/13/20.
//  Copyright © 2020 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

// open permits access and overrides from other classes
open class Spinner: UIActivityIndicatorView {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.large
    public static var baseBackColor = UIColor.black.withAlphaComponent(0.3)
    public static var baseColor = UIColor(red: 0, green: 162, blue: 224, alpha: 1)
    
    
    public static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        // Add observer to check for orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
        if spinner == nil, let window = UIApplication.shared.windows.first {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        DispatchQueue.main.async {
            if spinner != nil {
                spinner!.stopAnimating()
                spinner!.removeFromSuperview()
                spinner = nil
            }
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                stop()
                start()
            }
        }
    }
    
}
