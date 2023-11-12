//
//  Font+.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import SwiftUI

extension Font {
    enum FontSize: CGFloat {
        case largeTitle = 88
        case largeTitle2 = 80
        case title = 26
        case title2 = 24
        case body = 20
        case callout = 18
        case footnote = 16
        case caption = 14
        case caption2 = 12
    }
    
    static func pretendardSemibold(_ size: FontSize) -> Font {
        custom("Pretendard-Semibold", size: size.rawValue)
    }
    static func pretendardMedium(_ size: FontSize) -> Font {
        custom("Pretendard-Medium", size: size.rawValue)
    }
    static func IMHyemin(_ size: FontSize) -> Font {
        custom("IMHyemin-Bold", size: size.rawValue)
    }
    
    /// IMHyemin 폰트에서 lineHeight를 구현할 시 사용할 font's line height.
    /// - Parameter size: Font Size (Enum)
    /// - Returns: Line Spacing with specific size of font's line height.
    static func IMHyeminHeight(_ size: FontSize) -> CGFloat {
        let font = UIFont(name: "IMHyemin-Bold", size: size.rawValue)!
        
        return font.lineHeight
    }
}
