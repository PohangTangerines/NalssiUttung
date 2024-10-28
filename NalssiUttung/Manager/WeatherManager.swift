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
//    case current
//    case daily
//    case weekly
//    case detailed
    case all
}

class WeatherManager: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForcast: DailyForecast?
    @Published var weeklyForcast: WeeklyForecast?
    @Published var detailedWeather: DetailedWeather?
    
    var weather: Weather?
    
    func fetchWeather() async {
        let location = LocationManager.shared.location
        let weather = try? await WeatherService.shared.weather(for: location)
        self.weather = weather
        updateWeather(for: .all)
    }
    
    func fetchWeather(for location: CLLocation) async {
        let weather = try? await WeatherService.shared.weather(for: location)
        self.weather = weather
        updateWeather(for: .all)
    }
    
    private func updateWeather(for type: WeatherUpdateType) {
        switch type {
            case .all:
            self.updateCurrentWeather()
            self.updateDailyWeather()
            self.updateWeeklyWeather()
            self.updateDetailedWeather()
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
            self.currentWeather = CurrentWeather(currentTemperature: currentTemperature,
                                                 weatherCondition: weatherCondition,
                                                 lowestTemperature: lowestTemperature,
                                                 highestTemperature: highestTemperature)
        }

    }
    
    private func updateDailyWeather() {
        
    }
    
    private func updateWeeklyWeather() {
        
    }
    
    private func updateDetailedWeather() {
        
    }
}
