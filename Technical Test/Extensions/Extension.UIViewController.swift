//
//  Extension.UIViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiateFromStoryboard(_ name: String) -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }
        else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
}
