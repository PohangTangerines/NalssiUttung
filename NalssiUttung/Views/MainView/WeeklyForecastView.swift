//
//  WeeklyWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import SwiftUI

struct WeeklyForecastView: View {
    let weeklyForecast: WeeklyForecast
    @StateObject var viewModel = WeeklyForecastViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TextDivider(text: "주간 날씨")
                .padding(.bottom, 21.responsibleHeight)
            
            HStack(spacing: 0) {
                ForEach(weeklyForecast.days.indices, id: \.self) { index in
                    let data = weeklyForecast.days[index]
                    
                    VStack(spacing: 0) {
                        // MARK: day, date, weather icon
                        Text("\(data.day)")
                            .font(.pretendardMedium(.footnote))
                            .padding(.bottom, 3.responsibleHeight)
                        Text("\(data.date)")
                            .font(.pretendardMedium(.caption))
                            .padding(.bottom, 9.responsibleHeight)
                        Image(data.weatherCondition.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 28.responsibleWidth)
                            .padding(.bottom, 15.responsibleHeight)
                        
                        // MARK: Line Chart
                        GeometryReader { geometry in
                            let midX = geometry.size.width / 2
                            ZStack {
                                let chartMaxGap: Double = 90.responsibleHeight
                                let offsetDotPair = viewModel.getOffsetDot(nowData: data, dayData: weeklyForecast.days)
                                let highCoorY = offsetDotPair.first.responsibleHeight
                                let lowCoorY = offsetDotPair.second.responsibleHeight
                                
                                // MARK: high, low Temperature Line Path
                                let (highPath, lowPath) = viewModel.getChartLine(dayData: weeklyForecast.days, index: index, geometry: geometry)
                                highPath.stroke(Color.black, lineWidth: 2)
                                lowPath.stroke(Color.black, lineWidth: 2)
                                
                                // MARK: high, low Temperature Text
                                Text("\(data.highestTemperature)°")
                                    .font(.pretendardMedium(.footnote))
                                    .position(x: midX, y: highCoorY - 25.responsibleHeight)
                                Text("\(data.lowestTemperature)°")
                                    .font(.pretendardMedium(.footnote))
                                    .position(x: midX, y: lowCoorY + 25.responsibleHeight)
                                
                                // MARK: Temperature dots
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2))
                                        .frame(width: 8.responsibleWidth)
                                        .position(x: midX, y: highCoorY)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2))
                                        .frame(width: 8.responsibleWidth)
                                        .position(x: midX, y: lowCoorY)
                                }
                                .zIndex(1)
                                
                                // MARK: precipitation
                                Text("\(data.precipitationChance)")
                                    .font(.pretendardMedium(.caption2))
                                    .position(x: midX, y: chartMaxGap + 25.responsibleHeight + 40.responsibleHeight)
                            }
                        }
                        .frame(maxHeight: 140.responsibleHeight)
                    }
                }
            }
        }
        .padding(.bottom, 60.responsibleHeight)
        .offset(y: -25.responsibleHeight)
    }
}
