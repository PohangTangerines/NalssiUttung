//
//  DailyForecastView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/6/24.
//

import SwiftUI

struct DailyForecastView: View {
    @ObservedObject var dailyForecastViewModel: DailyForecastViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(dailyForecastViewModel.formattedHourlyWeathers.indices, id: \.self) { index in
                    let hourlyWeather = dailyForecastViewModel.formattedHourlyWeathers[index]
                    
                    VStack(spacing: 0) {
                        Text(hourlyWeather.time)
                            .font(.pretendardMedium(.footnote))
                            .padding(.bottom, 12.responsibleHeight)
                        
                        Image(hourlyWeather.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28.responsibleWidth)
                            .padding(.bottom, 20.responsibleHeight)
                        
                        // TODO: - Line Chart 분리하기
                        GeometryReader { geometry in
                            ZStack {
                                let coorY = geometry.size.height / 2 + 10 - dailyForecastViewModel.getOffsetDot(nowTemp: Int(hourlyWeather.temperature) ?? 0)
                                
                                dailyForecastViewModel.getChartLine(index: index, geometry: geometry)
                                    .stroke(Color.black, lineWidth: 2)
                                
                                if !hourlyWeather.isSunriseOrSunset {
                                    VStack(spacing: 0) {
                                        Circle()
                                            .fill(Color.white)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 2))
                                            .frame(width: 8.responsibleWidth)
                                            .position(x: geometry.size.width / 2, y: coorY)
                                    }
                                    .zIndex(1)
                                }
                            }
                        }
                        
                        Text(hourlyWeather.temperature)
                            .font(.pretendardMedium(.footnote))
                    }
                    .frame(width: 70.responsibleWidth)
                }
            }
            .frame(minHeight: 150)
        }
        .padding(.vertical, 10.5)
    }
}
