//
//  UIAlertController+Extension.swift
//  WeatherApp
//
//  Copyright © 2018 Alexsays. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .alert, actions: [UIAlertAction]) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions {
            self.addAction(action)
        }
    }
}

extension UIAlertAction {
    convenience init(_ title: String, isCancel: Bool = false, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: isCancel ? .cancel : .default, handler: handler)
    }
}
