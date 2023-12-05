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
                
                ScrolledMainViewTextDivider(text: "주간 날씨").padding(.bottom, 21.responsibleHeight)
                
                HStack(spacing: 0) {
                    ForEach(weeklyWeatherData.dayData.indices, id: \.self) { index in
                        let data = weeklyWeatherData.dayData[index]
                        
                        VStack(spacing: 0) {
                            // MARK: day, date, weather icon
                            Text("\(data.day)")
                                .font(.pretendardMedium(.footnote))
                                .padding(.bottom, 3.responsibleHeight)
                            Text("\(data.date)")
                                .font(.pretendardMedium(.caption))
                                .padding(.bottom, 9.responsibleHeight)
                            Image(data.weatherCondition.weatherIcon())
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 28.responsibleWidth)
                                .padding(.bottom, 30.responsibleHeight)
                            
                            // MARK: Line Chart
                            GeometryReader { geometry in
                                let midX = geometry.size.width / 2
                                ZStack {
                                    let chartMaxGap: Double = 90.responsibleHeight
                                    let offsetDotPair = getOffsetDot(nowData: data, dayData: weeklyWeatherData.dayData)
                                    let highCoorY = offsetDotPair.first.responsibleHeight
                                    let lowCoorY = offsetDotPair.second.responsibleHeight
                                    
                                    // MARK: high, low Temperature Line Path
                                    let (highPath, lowPath) = getChartLine(dayData: weeklyWeatherData.dayData, index: index, geometry: geometry)
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
                                    }.zIndex(1)
                                    
                                    // MARK: precipitation
                                    Text("\(data.precipitationChance)")
                                        .font(.pretendardMedium(.caption2))
                                        .position(x: midX, y: chartMaxGap + 25.responsibleHeight + 40.responsibleHeight)
                                }
                            }.frame(maxHeight: 140.responsibleHeight)
                        }
                    }
                } // HStack (Box)
                
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }.padding(.bottom, 30.responsibleHeight) // VStack (Whole)
    }
    
    private func getOffsetDot(nowData: WeeklyWeatherData.DayData, dayData: [WeeklyWeatherData.DayData]) -> (first: CGFloat, second: CGFloat) {
        let chartMaxGap: Double = 90
        // -100 -> dummy
        var minTemp: Int = 100
        var maxTemp: Int = -100
        
        for data in dayData {
            // 최소, 최대 온도 비교 및 업데이트
            minTemp = min(minTemp, data.lowestTemperature, data.highestTemperature)
            // 최대 온도 비교 및 업데이트
            maxTemp = max(maxTemp, data.lowestTemperature, data.highestTemperature)
        }
        
        let unitGap = 65 / Double(maxTemp - minTemp)
        let highTempOffSet = chartMaxGap - CGFloat( unitGap * Double(nowData.highestTemperature - minTemp) )
        let lowTempOffset = chartMaxGap - CGFloat( unitGap * Double(nowData.lowestTemperature - minTemp) )

        return (highTempOffSet, lowTempOffset)
    }
    
    // MARK: get Line of Chart (for 1 column)
    private func getChartLine(dayData: [WeeklyWeatherData.DayData], index: Int, geometry: GeometryProxy) -> (first: Path, second: Path) {
        let todayData = dayData[index]
        let offsetDotPair = getOffsetDot(nowData: todayData, dayData: dayData)
        let highCoorY = offsetDotPair.first.responsibleHeight
        let lowCoorY = offsetDotPair.second.responsibleHeight
        let geoX = geometry.size.width / 2
        
        var nextHighCoorY: CGFloat = 0
        var nextLowCoorY: CGFloat = 0
        var previousHighCoorY: CGFloat = 0
        var previousLowCoorY: CGFloat = 0
        
        if index > 0 {
            let previousDayData = dayData[index-1]
            previousHighCoorY = getOffsetDot(nowData: previousDayData, dayData: dayData).first.responsibleHeight
            previousLowCoorY = getOffsetDot(nowData: previousDayData, dayData: dayData).second.responsibleHeight
        }
        
        if index < 6 {
            let nextDayData = dayData[index+1]
            nextHighCoorY = getOffsetDot(nowData: nextDayData, dayData: dayData).first.responsibleHeight
            nextLowCoorY = getOffsetDot(nowData: nextDayData, dayData: dayData).second.responsibleHeight
        }
        
        let highPath = Path { path in
            // High Temperature Line
            if index == 0 {
                path.move(to: CGPoint(x: geoX, y: highCoorY))
            } else {
                path.move(to: CGPoint(x: 0, y: (highCoorY + previousHighCoorY)/2))
            }
            
            path.addLine(to: CGPoint(x: geoX, y: highCoorY))
                
            if index != 6 {
                path.addLine(to: CGPoint(x: geoX*2, y: (highCoorY + nextHighCoorY)/2))
            }
        }
        
        let lowPath = Path { path in
            // Low Temperature Line
            if index == 0 {
                path.move(to: CGPoint(x: geoX, y: lowCoorY))
            } else {
                path.move(to: CGPoint(x: 0, y: (lowCoorY + previousLowCoorY)/2))
            }
            
            path.addLine(to: CGPoint(x: geoX, y: lowCoorY))
                
            if index != 6 {
                path.addLine(to: CGPoint(x: geoX*2, y: (lowCoorY + nextLowCoorY)/2))
            }
        }
        
        return (highPath, lowPath)
    }
}
