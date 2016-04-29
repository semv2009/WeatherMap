//
//  UIViewController+ EZLoadingActivity.swift
//  WeatherMap
//
//  Created by developer on 29.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import EZLoadingActivity

extension UIViewController {
    func showLoadingView(text: String, disableUI disable: Bool) {
        EZLoadingActivity.show(text, disableUI: disable)
    }
    
    func hideLoadingView(text: String, success: Bool?, animated: Bool) {
        EZLoadingActivity.hideWithText(text, success: success, animated: animated)
    }
    
    func hideLoadingView() {
        EZLoadingActivity.hide()
    }
}
