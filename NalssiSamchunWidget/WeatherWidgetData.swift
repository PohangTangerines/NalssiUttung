//
//  WeatherWidgetData.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/24/24.
//

import Foundation
import CoreLocation
import WeatherKit

struct WeatherWidgetData {
    let address: String
    let temperature: Measurement<UnitTemperature>
    let character: String
}

extension WeatherWidgetData {
    static let previewData = WeatherWidgetData(address: "제주시 애월읍", temperature: Measurement(value: 24, unit: .celsius), character: "clearCharacter")
    static let placeholderData = WeatherWidgetData(address: "--", temperature: Measurement(value: 0, unit: .celsius), character: "clearCharacter")
}

extension WeatherWidgetData {
    static func currentWeather(for address: String) async throws -> WeatherWidgetData {
        // 현재 위치 정보
        let location = LocationManager.shared.findCoordinates(address: address) ?? CLLocation(latitude: 33.8463889, longitude: 126.8205556)
        
        // 현재 온도
        let weather = try await WeatherService.shared.weather(for: location)
        let temperature = weather.currentWeather.temperature
        
        // 현재 날씨 캐릭터
        let condition = weather.currentWeather.condition
        let sunrise = weather.dailyForecast.forecast.first!.sun.sunrise!
        let sunset = weather.dailyForecast.forecast.first!.sun.sunrise!
        let character = getWeatherCharacter(condition: condition, sunrise: sunrise, sunset: sunset)
        
        return WeatherWidgetData(address: address, temperature: temperature, character: character)
    }
    
    static func getWeatherCharacter(condition: WeatherCondition, sunrise: Date, sunset: Date) -> String {
        // 중복 함수, 데이터 결합도가 높아서 임시로 만들어 둠. 가능하면 refactor
        switch condition {
        case .clear, .mostlyClear, .hot :
            if sunrise.timeIntervalSinceNow < 0 && sunset.timeIntervalSinceNow > 0 {
                return "clearCharacter"
            } else {
                return "clearNightCharacter"
            }
        case .cloudy :
            return "cloudyCharacter"
        case .partlyCloudy, .mostlyCloudy :
            if sunrise.timeIntervalSinceNow < 0 && sunset.timeIntervalSinceNow > 0 {
                return "partlyCloudyCharacter"
            } else {
                return "partlyCloudyNightCharacter"
            }
        case .haze, .foggy, .blowingDust, .smoky :
            return "foggyCharacter"
        case .windy, .breezy :
            return "windyCharacter"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms, .tropicalStorm, .hurricane :
            return "thunderstormCharacter"
        case .rain, .drizzle, .freezingDrizzle, .sunShowers :
            return "rainCharacter"
        case .heavyRain :
            return "heavyRainCharacter"
        case .snow, .heavySnow, .blizzard, .blowingSnow, .flurries , .sunFlurries, .frigid, .hail:
            return "snowCharacter"
        case .freezingRain, .sleet, .wintryMix :
            return "freezingRainCharacter"
        default :
            return "clearCharacter"
        }
    }
}
