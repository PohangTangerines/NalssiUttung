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
        let character = condition.getWeatherCharacter(for: weather)
        
        return WeatherWidgetData(address: address, temperature: temperature, character: character)
    }
}
