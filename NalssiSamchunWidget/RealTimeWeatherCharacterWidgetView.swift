//
//  RealTimeWeatherCharacterWidgetView.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/18/24.
//

import SwiftUI
import WidgetKit

struct RealTimeWeatherCharacterWidgetView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("제주시 애월읍")
                    .customTextStyle(fontName: .pretendardSemibold, fontSize: 14)
                HStack(spacing: -7) {
                    Text("24")
                        .customTextStyle(fontName: .IMHyemin, fontSize: 32, kerning: -6)
                    Text("°")
                        .customTextStyle(fontName: .IMHyemin, fontSize: 32)
                }
            }
            .offset(x: -20, y: -30)
            Image("Clear")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .offset(y: 20)
        }
        .containerBackground(Color.seaSky, for: .widget)
    }
}
struct RealTimeWeatherCharacterWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeWeatherCharacterWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
