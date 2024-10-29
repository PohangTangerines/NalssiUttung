//
//  WeatherModel.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/28/24.
//

import CoreLocation
import WeatherKit

struct CurrentWeather {
    var temperature: Int
    var weatherCondition: WeatherCondition
    var lowestTemperature: Int
    var highestTemperature: Int
}

struct DailyForecast {
    var sunrise: Date
    var sunset: Date
    var hours: [Hour]
    
    struct Hour: Identifiable {
        var id = UUID()
        
        var time: Date
        var weatherCondition: WeatherCondition
        var temperature: Int
    }
    
    func indexOfSunrise() -> Int {
        return hours.firstIndex(where: { $0.time == sunrise })!
    }
    
    func indexOfSunset() -> Int {
        return hours.firstIndex(where: { $0.time == sunset })!
    }
}

struct WeeklyForecast {
    var days: [Day]
    
    struct Day: Identifiable {
        var id = UUID()
        
        var day: String
        var date: String
        var weatherCondition: WeatherCondition
        var lowestTemperature: Int
        var highestTemperature: Int
        var precipitationChance: String
    }
}

struct DetailedWeather {
    var precipitation: String
    var precipitationAmount: String
    var windDirection: String
    var windSpeed: String
    var visibility: String
}
