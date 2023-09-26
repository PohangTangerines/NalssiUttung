//
//  DailyWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/16.
//

import SwiftUI
import WeatherKit

struct DailyWeatherView: View {
    @Binding var dailyWeatherData: DailyWeatherData?
    
    var body: some View {
        ScrollView(.horizontal) {
            if let dailyWeatherData = dailyWeatherData {
                VStack(alignment: .leading) {
                    VStack {
                        HStack(spacing: 20) {
                            ForEach(dailyWeatherData.hourData , id: \.time) {
                                Text("\($0.time)")
                                    .font(.pretendardMedium(.footnote))
                            }
                        }
                        .padding(.bottom, 12)
                        HStack(spacing: 49) {
                            ForEach(dailyWeatherData.hourData, id: \.time) {
                                Image("\($0.weatherCondition.rawValue)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 28)
                            }
                        }
                        .offset(x:-5)
                    }
                    DailyWeatherChartView(dailyWeatherData: $dailyWeatherData)
                        .padding(.bottom, 20)
                        .offset(x: -28,  y: 20)
                    HStack(spacing: 52) {
                        ForEach(dailyWeatherData.hourData, id: \.time) {
                            Text("\($0.temperature)°")
                                .font(.pretendardMedium(.footnote))
                        }
                    }
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .padding(20)
    }
}
