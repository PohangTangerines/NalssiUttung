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
        VStack(spacing: 0) {
            if let weeklyWeatherData = weeklyWeatherData {
                
                ScrolledMainViewTextDivider(text: "주간 날씨").padding(.bottom, 21)
                
                HStack(spacing: 0) {
                    ForEach(weeklyWeatherData.dayData , id: \.date) { data in
                        VStack(spacing: 0) {
                            Text("\(data.day)")
                                .font(.pretendardMedium(.footnote))
                                .padding(.bottom, 3)
                            Text("\(data.date)")
                                .font(.pretendardMedium(.caption))
                                .padding(.bottom, 9)
                            Image(data.weatherCondition.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 28)
                        }
                    }
                }
                
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
    }
}
