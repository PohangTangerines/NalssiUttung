//
//  CGFloat+.swift
//  NalssiUttung
//
//  Created by 이재원 on 12/5/23.
//

import UIKit

extension CGFloat {
    enum ScreenType {
        case width, height
    }

    func deviceDependable(_ type: ScreenType) -> CGFloat {
        switch type {
        case .width:
            return UIScreen.screenWidth / 390 * self
        case .height:
            return UIScreen.screenHeight / 844 * self
        }
    }
}

extension Int {
    enum ScreenType {
        case width, height
    }

    var responsibleWidth: CGFloat {
        CGFloat(self).deviceDependable(.width)
    }
    var responsibleHeight: CGFloat {
        CGFloat(self).deviceDependable(.height)
    }
}
