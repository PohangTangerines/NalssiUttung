//
//  DailyWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/16.
//

import SwiftUI
import WeatherKit

struct DailyWeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let dailyForecast = weatherManager.dailyForecast {
                HStack(spacing: 0) {
                    ForEach(Array(zip(dailyForecast.hours.indices,
                                      dailyForecast.hours)), id: \.0) { index, data in
                        VStack(spacing: 0) {
                            Text(timeString(time:data.time))
                                .font(.pretendardMedium(.footnote))
                                .padding(.bottom, 9.responsibleHeight)
                            Image(weatherIconString(time: data.time, weather: data.weatherCondition))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28.responsibleWidth)
                                .padding(.bottom, 15.responsibleHeight)
                            
                            // MARK: Line Chart
                            GeometryReader { geometry in
                                ZStack {
                                    let coorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: data.temperature)
                                    
                                    getChartLine(index: index, geometry: geometry)
                                        .stroke(Color.black, lineWidth: 2)
                                    
                                    if index != dailyForecast.indexOfSunrise()
                                        && index != dailyForecast.indexOfSunset() {
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
                            Text(temperatureString(time: data.time, temp: data.temperature))
                                .font(.pretendardMedium(.footnote))
                        }
                        .frame(width: 70.responsibleWidth)
                    }
                }
                .frame(minHeight: 140)
                
            }
            
        }
        .padding(.vertical, 10.5)
    }
    
    private func timeString(time: Date) -> String {
        if [weatherManager.dailyForecast?.sunrise, weatherManager.dailyForecast?.sunset].contains(time) {
            return WeatherDataFormatter.timeWithMinutes(from: time)
        } else {
            return WeatherDataFormatter.timeWithHourOnly(from: time)
        }
    }
    
    private func temperatureString(time: Date, temp: Int) -> String {
        if time == weatherManager.dailyForecast?.sunrise {
            return "일출"
        } else if time == weatherManager.dailyForecast?.sunset {
            return "일몰"
        } else {
            return "\(temp)°"
        }
    }
    
    private func weatherIconString(time: Date, weather: WeatherCondition) -> String {
        if time == weatherManager.dailyForecast?.sunrise {
            return "sunrise"
        } else if time == weatherManager.dailyForecast?.sunset {
            return "sunset"
        } else {
            return "\(weather.icon)"
        }
    }
    
    private func getOffsetDot(nowTemp: Int) -> CGFloat {
        let minTemp = (weatherManager.dailyForecast?.hours.map { $0.temperature }.filter { $0 != 100 }.min() ?? 0)
        let maxTemp = (weatherManager.dailyForecast?.hours.map { $0.temperature }.filter { $0 != 100 }.max() ?? 0)
        
        return CGFloat( ( 30 / (maxTemp - minTemp) ) * (nowTemp - minTemp) )
    }
    
    private func getChartLine(index: Int, geometry: GeometryProxy) -> Path {
        let data = weatherManager.dailyForecast!.hours[index]
        let coorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: data.temperature)
        let geoX = geometry.size.width / 2
        var nextCoorY: CGFloat = 0
        var previousCoorY: CGFloat = 0
        
        let sunriseIndex = weatherManager.dailyForecast!.indexOfSunrise()
        let sunsetIndex = weatherManager.dailyForecast!.indexOfSunset()
        
        if index > 0 {
            let previousHourData = weatherManager.dailyForecast!.hours[index-1]
            previousCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: previousHourData.temperature)
        }
        
        if index < 25 {
            let nextHourData = weatherManager.dailyForecast!.hours[index+1]
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
                    let nnextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: weatherManager.dailyForecast!.hours[index+2].temperature)
                    
                    path.addLine(to: CGPoint(x: geoX*2, y: (coorY*3 + nnextCoorY)/4))
                }
            } else if [sunriseIndex + 1, sunsetIndex + 1].contains(index) {
                if index == 1 {
                    path.move(to: CGPoint(x: geoX, y: coorY))
                } else {
                    let ppextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: weatherManager.dailyForecast!.hours[index-2].temperature)
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
