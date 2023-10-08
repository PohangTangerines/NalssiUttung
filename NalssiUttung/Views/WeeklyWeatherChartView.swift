//
//  WeeklyWeatherChartView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import SwiftUI
import Charts

struct WeeklyWeatherChartView: View {
    @Binding var weeklyWeatherData: WeeklyWeatherData?

    var body: some View {
        VStack {
            if let weeklyWeatherData = weeklyWeatherData {
                VStack {
                    Chart {
                        ForEach(weeklyWeatherData.dayData, id: \.date) { week in
                            LineMark(
                                x: .value("index", week.date),
                                y: .value("value", week.highestTemperature)
                            )
                            .foregroundStyle(.black)
                            .offset(y: 20)
                            PointMark(
                                x: .value("index", week.date),
                                y: .value("value", week.highestTemperature)
                            )
                            .symbol {
                                VStack(spacing: 20) {
                                    Text("\(week.highestTemperature)")
                                        .foregroundColor(.black)
                                        .font(.pretendardMedium(.footnote))
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2))
                                        .frame(width: 8)
                                }
                            }
                        }
                    }
                    .chartYAxis(.hidden)
                    .chartXAxis(.hidden)
                    .aspectRatio(2.36, contentMode: .fit)
                    .padding(-40)
                    Spacer()
                    Chart {
                        ForEach(weeklyWeatherData.dayData, id: \.date) { week in
                            LineMark(
                                x: .value("index", week.date),
                                y: .value("value", week.lowestTemperature)
                            )
                            .foregroundStyle(.black)
                            .offset(y: -20)
                            PointMark(
                                x: .value("index", week.date),
                                y: .value("value", week.lowestTemperature)
                            )
                            .symbol {
                                VStack(spacing: 20) {
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2))
                                        .frame(width: 8)
                                    Text("\(week.lowestTemperature)")
                                        .foregroundColor(.black)
                                        .font(.pretendardMedium(.footnote))
                                }
                            }
                        }
                    }
                    .chartYAxis(.hidden)
                    .chartXAxis(.hidden)
                    .aspectRatio(2.36, contentMode: .fit)
                    .padding(-40)
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .frame(maxHeight: 164)
        .offset(y: 80)
    }
}
