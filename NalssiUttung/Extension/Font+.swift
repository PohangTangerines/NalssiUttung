//
//  Font+.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import SwiftUI

extension Font {
    enum DEFontSize: CGFloat {
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
    
    static func pretendardSemibold(_ size: DEFontSize) -> Font {
        custom("Pretendard-Semibold", size: size.rawValue)
    }
    static func pretendardMedium(_ size: DEFontSize) -> Font {
        custom("Pretendard-Medium", size: size.rawValue)
    }
    static func IMHyemin(_ size: DEFontSize) -> Font {
        custom("IMHyemin-Bold", size: size.rawValue)
    }
}