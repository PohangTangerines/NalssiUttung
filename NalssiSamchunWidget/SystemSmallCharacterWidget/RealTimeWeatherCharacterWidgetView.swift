//
//  RealTimeWeatherCharacterWidgetView.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/18/24.
//

import SwiftUI
import WidgetKit

struct RealTimeWeatherCharacterWidgetView: View {
    let data: WeatherCharacterWidgetData
    
    var body: some View {
        // 글자가 두 줄이 되는 경우 생김.
        // 에셋 바람/글자 두 줄이 되는 경우 생각해 보기
        
        // TODO: - 캐릭터 살짝 오른쪽으로 땡기기
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(data.address)
                    .customTextStyle(fontName: .pretendardSemibold, fontSize: 14)
                HStack(spacing: -7) {
                    Text("\(formattedTemperature(data.temperature))")
                        .customTextStyle(fontName: .IMHyemin, fontSize: 32, kerning: -6)
                    Text("°")
                        .customTextStyle(fontName: .IMHyemin, fontSize: 32)
                }
                .offset(x: -3)
            }
            .padding(.horizontal, 16)
            .offset(x: -20, y: -30)
            .foregroundStyle(.black)
            
            Image(data.character)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .offset(y: 25)
        }
        .containerBackground(Color.seaSky, for: .widget)
    }
    
    private func formattedTemperature(_ measurement: Measurement<UnitTemperature>) -> String {
        let value = measurement.value
        return String(Int(value))
    }
}

struct RealTimeWeatherCharacterWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RealTimeWeatherCharacterWidgetView(data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            // isPlaceholder(true)는 안됨
            RealTimeWeatherCharacterWidgetView(data: .previewData)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
        }
        
    }
}
