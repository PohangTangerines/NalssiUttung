//
//  DailyWeatherChartView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/16.
//

import SwiftUI
import Charts
import WeatherKit

struct DailyWeatherChartView: View {
    @Binding var dailyWeatherData: DailyWeatherData?
    
    var body: some View {
        VStack {
            if let dailyWeatherData = dailyWeatherData {
                Chart {
                    ForEach(dailyWeatherData.hourData, id: \.time) {
                        LineMark(
                            x: .value("index", $0.time),
                            y: .value("value", $0.temperature)
                        )
                        .foregroundStyle(.black)
                        PointMark(
                            x: .value("index", $0.time),
                            y: .value("value", $0.temperature)
                        )
                        .symbol {
                            Circle()
                                .fill(Color.white)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2))
                                .frame(width: 8)
                        }
                    }
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .aspectRatio(17.4, contentMode: .fit)
        .frame(height: 27)
    }
}
