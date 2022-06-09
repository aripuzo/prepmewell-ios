//
//  UIWindow+Extension.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 16/05/2022.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
