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
    
    private func timeString(time: Date) -> String {
        if [dailyWeatherData?.sunriseDate, dailyWeatherData?.sunsetDate].contains(time) {
            return dateToDetailTimeString(date: time)
        } else {
            return dateToTimeString(date: time)
        }
    }
    
    private func temperatureString(time: Date, temp: Int) -> String {
        if time == dailyWeatherData?.sunriseDate {
            return "일출"
        } else if time == dailyWeatherData?.sunsetDate {
            return "일몰"
        } else {
            return "\(temp)°"
        }
    }
    
    private func weatherIconString(time: Date, weather: WeatherCondition) -> String {
        if time == dailyWeatherData?.sunriseDate {
            return "sunrise"
        } else if time == dailyWeatherData?.sunsetDate {
            return "sunset"
        } else {
            return "\(weather.weatherIcon())"
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let dailyWeatherData = dailyWeatherData {
                HStack(spacing: 0) {
                    ForEach(Array(zip(dailyWeatherData.hourData.indices,
                                      dailyWeatherData.hourData)), id: \.0) { index, data in
                        VStack(spacing: 0) {
                            Text(timeString(time:data.time))
                                .font(.pretendardMedium(.footnote))
                                .padding(.bottom, 9.responsibleHeight)
                            Image(weatherIconString(time: data.time, weather: data.weatherCondition))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 28.responsibleWidth)
                                .frame(minWidth: 28.responsibleWidth)
                                .padding(.bottom, 15.responsibleHeight)
                            
                            // MARK: Line Chart
                            GeometryReader { geometry in
                                ZStack {
                                    let coorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: data.temperature)
                                    
                                    getChartLine(index: index, geometry: geometry)
                                        .stroke(Color.black, lineWidth: 2)
                                    
                                    if index != dailyWeatherData.indexOfSunrise()
                                        && index != dailyWeatherData.indexOfSunset() {
                                        VStack(spacing: 0) {
                                            Circle()
                                                .fill(Color.white)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.black, lineWidth: 2))
                                                .frame(width: 8.responsibleWidth)
                                                .position(x: geometry.size.width / 2, y: coorY)
                                        }.zIndex(1)
                                    }
                                }
                            }
                            
                            Text(temperatureString(time: data.time, temp: data.temperature))
                                .font(.pretendardMedium(.footnote))
                        }
                        .frame(width: 70.responsibleWidth)
                    }
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .padding(.vertical, 10.5)
    }
    
    private func getOffsetDot(nowTemp: Int) -> CGFloat {
        let minTemp = (dailyWeatherData?.hourData.map { $0.temperature }.filter { $0 != 100 }.min() ?? 0)
        let maxTemp = (dailyWeatherData?.hourData.map { $0.temperature }.filter { $0 != 100 }.max() ?? 0)
        
        return CGFloat( ( 30 / (maxTemp - minTemp) ) * (nowTemp - minTemp) )
    }
    
    private func getChartLine(index: Int, geometry: GeometryProxy) -> Path {
        let data = dailyWeatherData!.hourData[index]
        let coorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: data.temperature)
        let geoX = geometry.size.width / 2
        var nextCoorY: CGFloat = 0
        var previousCoorY: CGFloat = 0
        
        let sunriseIndex = dailyWeatherData!.indexOfSunrise()
        let sunsetIndex = dailyWeatherData!.indexOfSunset()
        
        if index > 0 {
            let previousHourData = dailyWeatherData!.hourData[index-1]
            previousCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: previousHourData.temperature)
        }
        
        if index < 25 {
            let nextHourData = dailyWeatherData!.hourData[index+1]
            nextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: nextHourData.temperature)
        }
        
        return Path { path in
            if [sunriseIndex, sunsetIndex].contains(index) {
                if index != 0 && index != 25 {
                    path.move(to: CGPoint(x: 0, y: (previousCoorY*3 + nextCoorY)/4))
                    path.addLine(to: CGPoint(x: geoX*2, y: (previousCoorY + nextCoorY*3)/4))
                }
            } else if [sunriseIndex - 1, sunsetIndex - 1].contains(index) {
                if index == 0 {
                    path.move(to: CGPoint(x: geoX, y: coorY))
                } else {
                    path.move(to: CGPoint(x: 0, y: (coorY + previousCoorY)/2))
                }
                path.addLine(to: CGPoint(x: geoX, y: coorY))
                
                if index != 24 {
                    let nnextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: dailyWeatherData!.hourData[index+2].temperature)
                    path.addLine(to: CGPoint(x: geoX*2, y: (coorY*3 + nnextCoorY)/4))
                }
            } else if [sunriseIndex + 1, sunsetIndex + 1].contains(index) {
                if index == 1 {
                    path.move(to: CGPoint(x: geoX, y: coorY))
                } else {
                    let ppextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: dailyWeatherData!.hourData[index-2].temperature)
                    path.move(to: CGPoint(x: 0, y: (ppextCoorY + coorY*3)/4))
                }
                
                path.addLine(to: CGPoint(x: geoX, y: coorY))
                if index != 25 {
                    path.addLine(to: CGPoint(x: geoX*2, y: (coorY + nextCoorY)/2))
                }
            } else {
                if index == 0 {
                    path.move(to: CGPoint(x: geoX, y: coorY))
                } else {
                    path.move(to: CGPoint(x: 0, y: (coorY + previousCoorY)/2))
                }
                path.addLine(to: CGPoint(x: geoX, y: coorY))
                if index != 25 {
                    path.addLine(to: CGPoint(x: geoX*2, y: (coorY + nextCoorY)/2))
                }
            }
        }
    }
    
}
