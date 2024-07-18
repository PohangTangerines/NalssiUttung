//
//  TextStyleExtension.swift
//  NalssiUttung
//
//  Created by 금가경 on 7/18/24.
//

import SwiftUI

extension Text {
    func customTextStyle(fontName: FontList, fontSize : CGFloat, kerning: CGFloat? = nil) -> some View {
        self
            .font(.custom(fontName.rawValue, size: fontSize))
            .kerning((kerning ?? 0) / 10)
    }
    
    enum FontList: String {
        case pretendardSemibold = "Pretendard-Semibold"
        case pretendardMedium = "Pretendard-Medium"
        case IMHyemin = "IMHyemin-Bold"
    }
    
}
