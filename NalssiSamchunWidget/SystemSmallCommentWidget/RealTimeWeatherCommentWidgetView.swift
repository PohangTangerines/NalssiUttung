//
//  RealTimeWeatherCommentWidgetView.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/29/24.
//

import SwiftUI
import WidgetKit

struct RealTimeWeatherCommentWidgetView: View {
    let data: WeatherCommentWidgetData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(data.address)
                .customTextStyle(fontName: .pretendardSemibold, fontSize: 14)
            HStack(spacing: -7) {
                Text("\(formattedTemperature(data.temperature))")
                    .customTextStyle(fontName: .IMHyemin, fontSize: 32, kerning: -6)
                Text("°")
                    .customTextStyle(fontName: .IMHyemin, fontSize: 32)
                Image(data.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
            }
            HStack {
                Text(data.comment)
                    .customTextStyle(fontName: .IMHyemin, fontSize: 14, lineHeight: 18)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .foregroundStyle(.black)
        .containerBackground(Color.seaSky, for: .widget)
    }
    
    private func formattedTemperature(_ measurement: Measurement<UnitTemperature>) -> String {
        let value = measurement.value
        return String(Int(value))
    }
}

struct RealTimeWeatherCommentWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RealTimeWeatherCommentWidgetView(data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            // isPlaceholder(true)는 안됨
            RealTimeWeatherCommentWidgetView(data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
        }
        
    }
}
