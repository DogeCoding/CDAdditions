//
//  CDConstantSwift.swift
//  CDAdditions
//
//  Created by 杨扶恺 on 2018/11/13.
//  Copyright © 2018 杨扶恺. All rights reserved.
//

import Foundation
import UIKit

// MARK: --- UI ---

open func UIColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColorFromRGB(rgbValue: rgbValue, alphaValue: 1)
}

open func UIColorFromRGB(rgbValue: Int, alphaValue: Float) -> UIColor {
    return UIColor(red: ((Float)(rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: ((Float)(rgbValue & 0xFF00) >> 8) / 255.0,
                   blue: ((Float)(rgbValue & 0xFF)) / 255.0,
                   alpha: alphaValue)
}

open func RandomColor() -> UIColor {
    return UIColor(hue: arc4random() % 256 / 256.0,
                   saturation: arc4random() % 128 / 256.0 + 0.5,
                   brightness: arc4random() % 128 / 256.0 + 0.5,
                   alpha: 1)
}

open let ScreenWidth = UIScreen.main.bounds.size.width
open let ScreenHeight = UIScreen.main.bounds.size.height
open let ScreenScale = UIScreen.main.scale

// MARK: --- Memory ---

// MARK: --- Multithreading ---
open func dispatch_main_async(_ completionHandler: @escaping () -> ()) {
    if Thread.isMainThread {
        completionHandler()
    } else {
        DispatchQueue.main.async {
            completionHandler()
        }
    }
}
