//
//  TextStyleExtension.swift
//  NalssiUttung
//
//  Created by 금가경 on 7/18/24.
//

import SwiftUI

extension Text {
    func customTextStyle(fontName: FontList, fontSize : CGFloat, lineHeight: CGFloat = 0, kerning: CGFloat = 0) -> some View {
        self
            .font(.custom(fontName.rawValue, size: fontSize))
            .kerning((kerning) / 10)
            .lineSpacing(fontSize / 2 * (lineHeight - 100) / 100)
    }
    
    enum FontList: String {
        case pretendardSemibold = "Pretendard-Semibold"
        case pretendardMedium = "Pretendard-Medium"
        case IMHyemin = "IMHyemin-Bold"
    }
    
}
