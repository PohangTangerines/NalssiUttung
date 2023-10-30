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
                    ForEach(weeklyWeatherData.dayData.indices, id: \.self) { index in
                        let data = weeklyWeatherData.dayData[index]
                        
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
                                .padding(.bottom, 15)
                            
                            // MARK: Line Chart
                            GeometryReader { geometry in
                                ZStack {
                                    let (highCoorY, lowCoorY) = getOffsetDot(nowData: data, dayData: weeklyWeatherData.dayData)
                                    let _ = print("날짜 : \(data.date)")
                                    let _ = print(data.lowestTemperature, data.highestTemperature)
                                    
                                    //                                getChartLine(index: index, geometry: geometry)
                                    //                                    .stroke(Color.black, lineWidth: 2)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 2))
                                            .frame(width: 8)
                                            .position(x: geometry.size.width / 2, y: highCoorY)
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 2))
                                            .frame(width: 8)
                                            .position(x: geometry.size.width / 2, y: lowCoorY)
                                    }.zIndex(1)
                                }
                            }.frame(minHeight: 60)
                            
                            //                        Text(temperatureString(time: data.time, temp: data.temperature))
                            //                            .font(.pretendardMedium(.footnote))
                            //                            .padding(.top, 15)
                        }
                    }
                }
                
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
    }
    
    private func getOffsetDot(nowData: WeeklyWeatherData.DayData, dayData: [WeeklyWeatherData.DayData]) -> (CGFloat, CGFloat) {
        // -100 -> dummy
        var minTemp: Int = 100
        var maxTemp: Int = -100
        
        for data in dayData {
            // 최소, 최대 온도 비교 및 업데이트
                minTemp = min(minTemp, data.lowestTemperature, data.highestTemperature)
            // 최대 온도 비교 및 업데이트
                maxTemp = data.highestTemperature
        }
        
        let unitGap = 52.5 / Double(maxTemp - minTemp)
        let highTempOffSet = 52.5 - CGFloat( unitGap * Double(nowData.highestTemperature - minTemp) )
        let lowTempOffset = 52.5 - CGFloat( unitGap * Double(nowData.lowestTemperature - minTemp) )
        
        return (highTempOffSet, lowTempOffset)
    }
    
    // MARK: get Line of Chart (for 1 column)

}
