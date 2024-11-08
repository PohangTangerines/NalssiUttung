//
//  DailyForecastViewModel.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/6/24.
//
import SwiftUI
import WeatherKit

struct FormattedHourlyWeather: Identifiable {
    var time: String
    var temperature: String
    var icon: String
    var isSunriseOrSunset: Bool
    
    var id: String { time }
}

class DailyForecastViewModel: ObservableObject {
    @Published var dailyForecast: DailyForecast {
        didSet {
            formatHourlyWeather()
        }
    }
    @Published var formattedHourlyWeathers: [FormattedHourlyWeather] = []
    
    init(dailyForecast: DailyForecast) {
        self.dailyForecast = dailyForecast
        formatHourlyWeather()
    }
    
    func formatHourlyWeather() {
        self.formattedHourlyWeathers = dailyForecast.hours.map { hour in
            let sunrise = dailyForecast.sunrise
            let sunset = dailyForecast.sunset
            
            let time = hour.time
            let temperature = hour.temperature
            let icon = hour.weatherCondition.icon
            
            if time != sunrise && time != sunset {
                return FormattedHourlyWeather(
                    time: WeatherDataFormatter.timeWithHourOnly(from: time),
                    temperature: "\(temperature)",
                    icon: "\(icon)",
                    isSunriseOrSunset: false
                )
            }
            
            return FormattedHourlyWeather(
                time: WeatherDataFormatter.timeWithMinutes(from: time),
                temperature: time == sunrise ? "일출" : "일몰",
                icon: time == sunrise ? "sunrise" : "sunset",
                isSunriseOrSunset: true
            )
        }
    }
    
    // TODO: - 차트 리팩토링
    func getOffsetDot(nowTemp: Int) -> CGFloat {
        let minTemp = (dailyForecast.hours.map { $0.temperature }.filter { $0 != 100 }.min() ?? 0)
        let maxTemp = (dailyForecast.hours.map { $0.temperature }.filter { $0 != 100 }.max() ?? 0)
        
        return CGFloat( ( 30 / (maxTemp - minTemp) ) * (nowTemp - minTemp) )
    }
    
    func getChartLine(index: Int, geometry: GeometryProxy) -> Path {
        let data = dailyForecast.hours[index]
        let coorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: data.temperature)
        let geoX = geometry.size.width / 2
        var nextCoorY: CGFloat = 0
        var previousCoorY: CGFloat = 0
        
        let sunriseIndex = dailyForecast.indexOfSunrise()
        let sunsetIndex = dailyForecast.indexOfSunset()
        
        if index > 0 {
            let previousHourData = dailyForecast.hours[index-1]
            previousCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: previousHourData.temperature)
        }
        
        if index < 25 {
            let nextHourData = dailyForecast.hours[index+1]
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
                    let nnextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: dailyForecast.hours[index+2].temperature)
                    
                    path.addLine(to: CGPoint(x: geoX*2, y: (coorY*3 + nnextCoorY)/4))
                }
            } else if [sunriseIndex + 1, sunsetIndex + 1].contains(index) {
                if index == 1 {
                    path.move(to: CGPoint(x: geoX, y: coorY))
                } else {
                    let ppextCoorY = geometry.size.height / 2 + 10 - getOffsetDot(nowTemp: dailyForecast.hours[index-2].temperature)
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
