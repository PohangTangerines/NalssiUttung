//
//  WeeklyWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import SwiftUI

struct WeeklyWeatherView: View {
    @Binding var weeklyWeatherData: WeeklyWeatherData?

    var body: some View {
        VStack(spacing: 28) {
            if let weeklyWeatherData = weeklyWeatherData {
                HStack {
                    Rectangle()
                        .frame(maxHeight: 2)
                    Text("주간 날씨")
                        .font(.IMHyemin(.footnote))
                        .padding(.horizontal, 16)
                    Rectangle()
                        .frame(maxHeight: 2)
                }
                VStack {
                    VStack {
                        HStack(spacing: 24) {
                            ForEach(weeklyWeatherData.dayData , id: \.date) { week in
                                VStack {
                                    Text("\(week.day)")
                                        .font(.pretendardMedium(.footnote))
                                    Text("\(week.date)")
                                        .font(.pretendardMedium(.caption))
                                    Image(week.weatherCondition.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 28)
                                }
                            }
                        }
                    }
                    WeeklyWeatherChartView(weeklyWeatherData: $weeklyWeatherData)
                    HStack(spacing: 33) {
                        ForEach(weeklyWeatherData.dayData, id: \.date) {
                            Text($0.precipitationChance)
                                .font(.pretendardMedium(.caption2))
                        }
                    }
                }
            }
            else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .padding(.horizontal, 20)
    }
}
//struct DailyWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyWeatherView(weeklyWeatherData: .constant(WeeklyWeatherData.sampleData))
//    }
//}
