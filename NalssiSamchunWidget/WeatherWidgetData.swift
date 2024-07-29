//
//  WeatherWidgetData.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/24/24.
//

import Foundation
import CoreLocation
import WeatherKit

struct WeatherCharacterWidgetData {
    let address: String
    let temperature: Measurement<UnitTemperature>
    let character: String
}

extension WeatherCharacterWidgetData {
    static let previewData = WeatherCharacterWidgetData(address: "제주시 애월읍", temperature: Measurement(value: 24, unit: .celsius), character: "clearCharacter")
    static let placeholderData = WeatherCharacterWidgetData(address: "--", temperature: Measurement(value: 0, unit: .celsius), character: "clearCharacter")
}

extension WeatherCharacterWidgetData {
    static func currentWeather(for address: String?) async throws -> WeatherCharacterWidgetData {
        // 현재 위치 정보
        let address = address ?? "제주공항"
        let location = LocationManager.shared.findCoordinates(address: address) ?? CLLocation(latitude: 33.8463889, longitude: 126.8205556)
        
        // 현재 온도
        let weather = try await WeatherService.shared.weather(for: location)
        let temperature = weather.currentWeather.temperature
        
        // 현재 날씨 캐릭터
        let condition = weather.currentWeather.condition
        let character = condition.getWeatherCharacter(for: weather)
        
        return WeatherCharacterWidgetData(address: address, temperature: temperature, character: character)
    }
}
