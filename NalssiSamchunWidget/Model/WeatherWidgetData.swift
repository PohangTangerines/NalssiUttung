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
}

extension WeatherCharacterWidgetData {
    static func currentWeather(for address: String?) async throws -> WeatherCharacterWidgetData {
        // 현재 위치 정보
        guard let address else { throw CustomWeatherError.noAddress }
        
        print("현재 주소는: \(address)")
        guard let locationInfo: LocationInfo = LocationManager.shared.findLocationInfo(from: address) else {
            throw CustomWeatherError.noLocationInfo
        }
        
        let location = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
        print("현재 위치는: \(location)")
        // 현재 온도
        let weather = try await WeatherService.shared.weather(for: location)
        let temperature = weather.currentWeather.temperature
        
        // 현재 날씨 캐릭터
        let condition = weather.currentWeather.condition

        guard let sunrise = weather.dailyForecast.forecast.first?.sun.sunrise,
           let sunset = weather.dailyForecast.forecast.first?.sun.sunset else {
            throw CustomWeatherError.sunEventUnavailable
        }
        
        let character = condition.character(sunrise: sunrise, sunset: sunset)

        return WeatherCharacterWidgetData(address: address, temperature: temperature, character: character)
    }
}

struct WeatherCommentWidgetData {
    let address: String
    let temperature: Measurement<UnitTemperature>
    let icon: String
    let comment: String
}

extension WeatherCommentWidgetData {
    static let previewData = WeatherCommentWidgetData(address: "제주시 애월읍", temperature: Measurement(value: 24, unit: .celsius), icon: "dayClear", comment: "바람 강하니 촐람생이처럼 바당 가지 말앙 들어가 있어라")
}

extension WeatherCommentWidgetData {
    static func currentWeather(for address: String?) async throws -> WeatherCommentWidgetData {
        // 현재 위치 정보
        guard let address = address else { throw CustomWeatherError.noAddress }
        
        guard let locationInfo = LocationManager.shared.findLocationInfo(from: address) else {
            throw CustomWeatherError.noLocationInfo
        }
        let location = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
        
        // 현재 온도
        let weather = try await WeatherService.shared.weather(for: location)
        let temperature = weather.currentWeather.temperature
        
        // 현재 날씨 아이콘, 멘트
        let condition = weather.currentWeather.condition
        let icon = condition.icon
        
        guard let sunrise = weather.dailyForecast.forecast.first?.sun.sunrise,
           let sunset = weather.dailyForecast.forecast.first?.sun.sunset else {
            throw CustomWeatherError.sunEventUnavailable
        }
                
        let comment = condition.comment(sunrise: sunrise, sunset: sunset)
        
        return WeatherCommentWidgetData(address: address, temperature: temperature, icon: icon, comment: comment)
    }
}
