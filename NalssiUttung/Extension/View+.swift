//
//  View+.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/03.
//

import SwiftUI

extension View {
    /// IMHyemin Font 사용 시의 LineHeight 지정.
    /// - Parameters:
    ///   - size: Font size. DEFontSize enum값.
    ///   - lineHeight: 설정할 Line Height.
    /// - Returns: LineHeight가 지정된 View를 return.
    func IMHyeminLineHeight(_ size: Font.DEFontSize, lineHeight: CGFloat) -> some View {
        self.lineSpacing(lineHeight - Font.IMHyeminHeight(size))
            .padding(.vertical, (lineHeight - Font.IMHyeminHeight(size)) / 2)
    }
}
