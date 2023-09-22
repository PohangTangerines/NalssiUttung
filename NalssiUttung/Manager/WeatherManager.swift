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
/// Navigation 시 Binding으로 간결하게 데이터를 넘겨주기 위해, struct 내부에 weather 객체를 포함했습니다.
struct WeatherBoxData {
    var location: CLLocation
    var weather: Weather
    
    var currentTemperature: Measurement<UnitTemperature>
    var weatherCondition: WeatherCondition
    var lowTemperature: Measurement<UnitTemperature>
    var highTemperature: Measurement<UnitTemperature>
}

/// MainView에서 사용될 아래쪽의 일일 날씨 정보.
struct DailyWeatherData {
    var weather: Weather
    
    var sunriseDate: Date
    var sunsetDate: Date
    var hourData: [SimpleHourData]
    
    struct SimpleHourData {
        var date: Date
        var weatherCondition: WeatherCondition
        var temperature: Measurement<UnitTemperature>
    }
}

/// DetailView에서 사용될 주간 날씨 정보.
struct WeeklyWeatherData {
    var weather: Weather
    
    var dayData: [DayData]
    
    struct DayData {
        var date: Date  // 날짜에 이용
        var weatherCondition: WeatherCondition
        var lowTemperature: Measurement<UnitTemperature>
        var highTemperature: Measurement<UnitTemperature>
        var rainProbability: Double
    }
}

struct CurrentDetailWeatherData {
    var precipitation: Precipitation
    var precipitationAmount: Measurement<UnitLength>
    var wind: Wind
    var visibility: Measurement<UnitLength>
}

extension WeatherService {
    /// 현재 위치를 기반으로, Weather 객체를 반환합니다.
    /// - Parameter location: 현재 위도, 경도를 기반으로 한 CLLocation 객체
    /// - Returns: Weather 객체 (Optional)
    func getWeather(location: CLLocation) async -> Weather? {
        do {
            let weather = try await WeatherService.shared.weather(for: location)
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
        
        return WeatherBoxData(location: location, weather: weather, currentTemperature: currentTemperature, weatherCondition: weatherCondition, lowTemperature: lowTemperature, highTemperature: highTemperature)
    }
    
    func getDailyWeatherData(weather: Weather) -> DailyWeatherData {
        let filteredHourWeather = weather.hourlyForecast.forecast.filter { hourWeather in
            (hourWeather.date.timeIntervalSinceNow/3600) > 0 && (hourWeather.date.timeIntervalSinceNow/3600) < 24
        }
        
        var hourData: [DailyWeatherData.SimpleHourData] = []
        filteredHourWeather.forEach { hourWeather in
            let date = hourWeather.date
            let condition = hourWeather.condition
            let temperature = hourWeather.temperature
            
            hourData.append(DailyWeatherData.SimpleHourData(date: date, weatherCondition: condition, temperature: temperature))
        }
        
        // TODO: force unwrapping handling
        let sunriseDate = weather.dailyForecast.forecast.first!.sun.sunrise!
        let sunsetDate = weather.dailyForecast.forecast.first!.sun.sunset!
        
        return DailyWeatherData(weather: weather, sunriseDate: sunriseDate, sunsetDate: sunsetDate, hourData: hourData)
    }
    
    func getWeeklyWeatherData(weather: Weather) -> WeeklyWeatherData {
        let filteredDayWeather = weather.dailyForecast.forecast.filter { dayWeather in
            (dayWeather.date.timeIntervalSinceNow/3600) > -24 && (dayWeather.date.timeIntervalSinceNow/3600) < 144
        }
        
        var dayData: [WeeklyWeatherData.DayData] = []
        filteredDayWeather.forEach { dayWeather in
            let date = dayWeather.date
            let weatherCondition = dayWeather.condition
            let lowTemperature = dayWeather.lowTemperature
            let highTemperature = dayWeather.highTemperature
            let rainProbability = dayWeather.precipitationChance
            
            dayData.append(WeeklyWeatherData.DayData(date: date, weatherCondition: weatherCondition, lowTemperature: lowTemperature, highTemperature: highTemperature, rainProbability: rainProbability))
        }
        
        return WeeklyWeatherData(weather: weather, dayData: dayData)
    }
    
    func getCurrentDetailWeatherData(weather: Weather) -> CurrentDetailWeatherData {
        let wind = weather.currentWeather.wind
        let visibility = weather.currentWeather.visibility
        // currentWeather에는 강수량이 존재하지 않아, hourlyForecase의 현재 시간 범위의 강수량을 사용.
        let hourWeather = weather.hourlyForecast.forecast.filter { hourWeather in (hourWeather.date.timeIntervalSinceNow/3600) >= -1 && (hourWeather.date.timeIntervalSinceNow/3600) < 0
        }.first!
        
        let precipitation = hourWeather.precipitation
        let precipitationAmount = hourWeather.precipitationAmount
        
        return CurrentDetailWeatherData(precipitation: precipitation, precipitationAmount: precipitationAmount, wind: wind, visibility: visibility)
    }
}

func unitTempToDouble(temp: Measurement<UnitTemperature>) -> Double {
    return temp.converted(to: .celsius).value
}
