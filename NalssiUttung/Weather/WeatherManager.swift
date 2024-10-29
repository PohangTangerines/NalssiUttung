//
//  WeatherManager.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/22/24.
//

import CoreLocation
import SwiftUI
import WeatherKit

enum WeatherUpdateType {
    // TODO: - 추후 필요한 타입 추가
    case current
    case all
}

class WeatherManager: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: DailyForecast?
    @Published var weeklyForecast: WeeklyForecast?
    @Published var detailedWeather: DetailedWeather?
    
    var weather: Weather?

    func fetchWeather(with type: WeatherUpdateType) async {
        let location = LocationManager.shared.location
        let weather = try? await WeatherService.shared.weather(for: location)
        self.weather = weather
        updateWeather(with: type)
    }
    
    func fetchWeather(for location: CLLocation, with type: WeatherUpdateType) async {
        let weather = try? await WeatherService.shared.weather(for: location)
        self.weather = weather
        updateWeather(with: type)
    }
    
    private func updateWeather(with type: WeatherUpdateType) {
        switch type {
            
        case .all:
        self.updateCurrentWeather()
        self.updateDailyWeather()
        self.updateWeeklyWeather()
        self.updateDetailedWeather()
            
        case .current:
            self.updateCurrentWeather()
        }
    }
    
    private func updateCurrentWeather() {
        guard let weather = weather else { return }
        
        let currentTemperature = unitTempToInt(temp: weather.currentWeather.temperature)
        let weatherCondition = weather.currentWeather.condition
        
        guard let first = weather.dailyForecast.forecast.first else { return }
        
        let lowestTemperature = unitTempToInt(temp: first.lowTemperature)
        let highestTemperature = unitTempToInt(temp: first.highTemperature)
        
        DispatchQueue.main.async {
            self.currentWeather = CurrentWeather(temperature: currentTemperature,
                                                 weatherCondition: weatherCondition,
                                                 lowestTemperature: lowestTemperature,
                                                 highestTemperature: highestTemperature)
        }
    }
    
    private func updateDailyWeather() {
        guard let weather = weather else { return }
        
        let filteredHourlyForecast = weather.hourlyForecast.forecast.filter { hourlyforecast in
            (hourlyforecast.date.timeIntervalSinceNow/3600) > 0 && (hourlyforecast.date.timeIntervalSinceNow/3600) < 24
        }
        
        var hours: [DailyForecast.Hour] = []
        
        filteredHourlyForecast.forEach { hourlyForecast in
            let time = hourlyForecast.date
            let condition = hourlyForecast.condition
            
            let temperature = hourlyForecast.temperature
            let convertedTemperature = unitTempToInt(temp: temperature)
            
            hours.append(DailyForecast.Hour(time: time, weatherCondition: condition, temperature: convertedTemperature))
        }
        
        // 일출/일몰 시간이 지나면, 다음 날의 일출/일몰 시간을 표시.
        var sunrise: Date {
            if let todaySunriseDate = weather.dailyForecast.forecast.first?.sun.sunrise {
                if todaySunriseDate.timeIntervalSinceNow > 0 {
                    return todaySunriseDate
                }
            }
            return weather.dailyForecast.forecast[1].sun.sunrise ?? Date() // 기본값으로 현재 날짜 반환
        }
        
        var sunset: Date {
            if let todaySunsetDate = weather.dailyForecast.forecast.first?.sun.sunset {
                if todaySunsetDate.timeIntervalSinceNow > 0 {
                    return todaySunsetDate
                }
            }
            
            return weather.dailyForecast.forecast[1].sun.sunset ?? Date() // 기본값으로 현재 날짜 반환
        }
        
        // sunrise, sunset data append. weatherCondition과 temperature data - dummy.
        hours.append(DailyForecast.Hour(time: sunrise, weatherCondition: .clear, temperature: 100))
        hours.append(DailyForecast.Hour(time: sunset, weatherCondition: .clear, temperature: 100))
        
        // 시간 순 정렬
        hours.sort { $0.time < $1.time }
        
        DispatchQueue.main.async {
            self.dailyForecast = DailyForecast(sunrise: sunrise,
                                               sunset: sunset,
                                               hours: hours)
        }
    }
    
    private func updateWeeklyWeather() {
        guard let weather = weather else { return }
        
        let filteredDailyForecast = weather.dailyForecast.forecast.filter { dayWeather in
            (dayWeather.date.timeIntervalSinceNow/3600) > -24 && (dayWeather.date.timeIntervalSinceNow/3600) < 144
        }
        
        var days: [WeeklyForecast.Day] = []
        filteredDailyForecast.forEach { dailyForecast in
            let date = dailyForecast.date
            
            let day = dateToDayString(date: date)
            let convertedDate = dateToString(date: date)
            
            let weatherCondition = dailyForecast.condition
            let lowestTemperature = unitTempToInt(temp: dailyForecast.lowTemperature)
            let highestTemperature = unitTempToInt(temp: dailyForecast.highTemperature)
            let precipitationChance = precipitationChanceDoubleToPercentage(precipitationChance: dailyForecast.precipitationChance)
            
            days.append(WeeklyForecast.Day(day: day, date: convertedDate, weatherCondition: weatherCondition, lowestTemperature: lowestTemperature, highestTemperature: highestTemperature, precipitationChance: precipitationChance))
        }
        
        DispatchQueue.main.async {
            self.weeklyForecast = WeeklyForecast(days: days)
        }
    }
    
    private func updateDetailedWeather() {
        guard let weather = weather else { return }
        
        let windDirection = weather.currentWeather.wind.compassDirection
        let convertedWindDirection = convertToKoreanWindDirection(windDirection.rawValue)

        let windSpeed = weather.currentWeather.wind.speed
        let convertedWindSpeed = unitWindSpeedToString(windSpeed: windSpeed)
        
        // 좋음/꽤 좋음/매우 좋음 등으로 표현하는 가시거리 존재하지 않음.
        let visibility = weather.currentWeather.visibility
        let convertedVisibility = visibilityUnitLengthToString(visibility: visibility)
        
        // currentWeather에는 강수량이 존재하지 않아, hourlyForecase의 현재 시간 범위의 강수량을 사용.
        let hourlyForecast = weather.hourlyForecast.forecast.filter { hourlyForecast in (hourlyForecast.date.timeIntervalSinceNow/3600) >= -1 && (hourlyForecast.date.timeIntervalSinceNow/3600) < 0
        }.first!
        
        let precipitation = hourlyForecast.precipitation
        let convertedPrecipitation = precipitationToKoreanString(precipitation.rawValue)
        
        let precipitationAmount = hourlyForecast.precipitationAmount
        let convertedPrecipitationAmount = precipitationUnitLengthToString(precipitationAmount: precipitationAmount)
        
        DispatchQueue.main.async {
            self.detailedWeather = DetailedWeather(precipitation: convertedPrecipitation,
                                                   precipitationAmount: convertedPrecipitationAmount,
                                                   windDirection: convertedWindDirection,
                                                   windSpeed: convertedWindSpeed,
                                                   visibility: convertedVisibility)
        }
    }
}
