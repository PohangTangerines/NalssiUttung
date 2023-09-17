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
    static let shared = WeatherManager()
    
    let manager = WeatherService()
    
    /// 현재 위치를 기반으로, Weather 객체를 반환합니다.
    /// - Parameter location: 현재 위도, 경도를 기반으로 한 CLLocation 객체
    /// - Returns: Weather 객체 (Optional)
    func getWeather(location: CLLocation) async -> Weather? {
        do {
            let weather = try await WeatherManager.shared.manager.weather(for: location)
            return weather
        } catch {
            print("Error Occurred in getWeather: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Weather 객체를 기반으로, `WeatherBoxData` 객체를 반환합니다.
    /// - Parameters:
    ///   - location: 현재 위도, 경도를 기반으로 한 CLLocation 객체
    ///   - weather: Weather 객체
    /// - Returns: WeatherBoxData 객체
    func getWeatherBoxData(location: CLLocation, weather: Weather) -> WeatherBoxData {
        let currentTemperature = weather.currentWeather.temperature
        let weatherCondition = weather.currentWeather.condition
        // TODO: force unwrapping error handling
        let lowTemperature = weather.dailyForecast.forecast.first!.lowTemperature
        let highTemperature = weather.dailyForecast.forecast.first!.highTemperature
        
        return WeatherBoxData(location: location, currentTemperature: currentTemperature, weatherCondition: weatherCondition, lowTemperature: lowTemperature, highTemperature: highTemperature)
    }
}

func unitTempToDouble(temp: Measurement<UnitTemperature>) -> Double {
    return temp.converted(to: .celsius).value
}
