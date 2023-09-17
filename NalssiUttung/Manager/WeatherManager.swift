//
//  WeatherManager.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/17.
//

import Foundation
import WeatherKit
import CoreLocation

/// LocationListView에서 쓰이는 날씨 박스 내의 데이터를 관리하기 위해 사용하는 구조체입니다.
/// 현재 온도, 날씨, 최저/최고 온도만을 지닙니다.
struct WeatherBoxData {
    var location: CLLocation
    
    var currentTemperature: Measurement<UnitTemperature>
    var weatherCondition: WeatherCondition
    var lowTemperature: Measurement<UnitTemperature>
    var highTemperature: Measurement<UnitTemperature>
}

class WeatherManager: ObservableObject {
    static let shared = WeatherService()
    
    //    @Published var weather: Weather?
    
    func getWeatherBoxData(location: CLLocation) async -> WeatherBoxData? {
        do {
            let weather = try await WeatherManager.shared.weather(for: location)
            
            let currentTemperature = weather.currentWeather.temperature
            let weatherCondition = weather.currentWeather.condition
            // TODO: force unwrapping error handling
            let lowTemperature = weather.dailyForecast.forecast.first!.lowTemperature
            let highTemperature = weather.dailyForecast.forecast.first!.highTemperature
            
            return WeatherBoxData(location: location, currentTemperature: currentTemperature, weatherCondition: weatherCondition, lowTemperature: lowTemperature, highTemperature: highTemperature)
        } catch {
            print("Error Occurred in getWeatherBoxData: \(error.localizedDescription)")
            return nil
        }
    }
}
