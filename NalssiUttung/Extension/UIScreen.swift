//
//  UIScreen.swift
//  NalssiUttung
//
//  Created by 이재원 on 12/5/23.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

    static func getWidth(_ width: CGFloat) -> CGFloat {
        screenWidth / 390 * width
    }
    
    static func getHeight(_ height: CGFloat) -> CGFloat {
        screenHeight / 844 * height
    }
}
