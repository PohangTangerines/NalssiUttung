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
    
    var currentTemperature: Int
    var weatherCondition: WeatherCondition
    var lowestTemperature: Int
    var highestTemperature: Int
}

/// MainView에서 사용될 아래쪽의 일일 날씨 정보.
struct DailyWeatherData {
    var weather: Weather
    
    var sunriseDate: Date
    var sunsetDate: Date
    var hourData: [SimpleHourData]
    
    struct SimpleHourData {
        var time: String
        var weatherCondition: WeatherCondition
        var temperature: Int
    }
}

/// DetailView에서 사용될 주간 날씨 정보.
struct WeeklyWeatherData {
    var weather: Weather
    
    var dayData: [DayData]
    
    struct DayData {
        var day: String
        var date: String
        var weatherCondition: WeatherCondition
        var lowestTemperature: Int
        var highestTemperature: Int
        var precipitationChance: String
    }
}

struct DetailedWeatherData {
    var precipitation: String
    var precipitationAmount: String
    var windDirection: String
    var windSpeed: String
    var visibility: String
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
        let currentTemperature = unitTempToInt(temp: weather.currentWeather.temperature)
        let weatherCondition = weather.currentWeather.condition
        
        // TODO: force unwrapping error handling
        let lowestTemperature = unitTempToInt(temp: weather.dailyForecast.forecast.first!.lowTemperature)
        let highestTemperature = unitTempToInt(temp: weather.dailyForecast.forecast.first!.highTemperature)
        
        return WeatherBoxData(location: location, weather: weather, currentTemperature: currentTemperature, weatherCondition: weatherCondition, lowestTemperature: lowestTemperature, highestTemperature: highestTemperature)
    }
    
    func getDailyWeatherData(weather: Weather) -> DailyWeatherData {
        let filteredHourWeather = weather.hourlyForecast.forecast.filter { hourWeather in
            (hourWeather.date.timeIntervalSinceNow/3600) > 0 && (hourWeather.date.timeIntervalSinceNow/3600) < 24
        }
        var hourData: [DailyWeatherData.SimpleHourData] = []
        filteredHourWeather.forEach { hourWeather in
            let convertedTime = dateToTimeString(date: hourWeather.date)
            
            let condition = hourWeather.condition
            
            let temperature = hourWeather.temperature
            let convertedTemperature = unitTempToInt(temp: temperature)

            hourData.append(DailyWeatherData.SimpleHourData(time: convertedTime, weatherCondition: condition, temperature: convertedTemperature))
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
            
            let day = dateToDayString(date: date)
            let convertedDate = dateToString(date: date)
            
            let weatherCondition = dayWeather.condition
            let lowestTemperature = unitTempToInt(temp: dayWeather.lowTemperature)
            let highestTemperature = unitTempToInt(temp: dayWeather.highTemperature)
            let precipitationChance = precipitationChanceDoubleToPercentage(precipitationChance: dayWeather.precipitationChance)
            
            dayData.append(WeeklyWeatherData.DayData(day: day, date: convertedDate, weatherCondition: weatherCondition, lowestTemperature: lowestTemperature, highestTemperature: highestTemperature, precipitationChance: precipitationChance))
        }
        
        return WeeklyWeatherData(weather: weather, dayData: dayData)
    }
    
    func getDetailedWeatherData(weather: Weather) -> DetailedWeatherData {
        let windDirection = weather.currentWeather.wind.compassDirection
        let convertedWindDirection = convertToKoreanWindDirection(windDirection.rawValue)

        let windSpeed = weather.currentWeather.wind.speed
        let convertedWindSpeed = unitWindSpeedToString(windSpeed: windSpeed)
        
        // 좋음/꽤 좋음/매우 좋음 등으로 표현하는 가시거리 존재하지 않음.
        let visibility = weather.currentWeather.visibility
        let convertedVisibility = visibilityUnitLengthToString(visibility: visibility)
        
        // currentWeather에는 강수량이 존재하지 않아, hourlyForecase의 현재 시간 범위의 강수량을 사용.
        let hourWeather = weather.hourlyForecast.forecast.filter { hourWeather in (hourWeather.date.timeIntervalSinceNow/3600) >= -1 && (hourWeather.date.timeIntervalSinceNow/3600) < 0
        }.first!
        
        let precipitation = hourWeather.precipitation
        let convertedPrecipitation = precipitationToKoreanString(precipitation.rawValue)
        
        let precipitationAmount = hourWeather.precipitationAmount
        let convertedPrecipitationAmount = precipitationUnitLengthToString(precipitationAmount: precipitationAmount)
                
        return DetailedWeatherData(precipitation: convertedPrecipitation, precipitationAmount: convertedPrecipitationAmount, windDirection: convertedWindDirection, windSpeed: convertedWindSpeed, visibility: convertedVisibility)
    }

    func getWeatherInfoForAddress(address: String) async -> WeatherBoxData? {
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            guard let location = placemarks.first?.location else {
                print("Location not found for address: \(address)")
                return nil
            }

            // WeatherService.shared.getWeather 함수도 async 함수이므로 await 키워드를 사용하여 호출합니다.
            if let weather = try? await WeatherService.shared.getWeather(location: location) {
                let weatherBoxData = WeatherService.shared.getWeatherBoxData(location: location, weather: weather)
                return weatherBoxData
            } else {
                print("Failed to fetch weather data")
                return nil
            }
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            return nil
        }
    }
}

func unitTempToInt(temp: Measurement<UnitTemperature>) -> Int {
    return Int(temp.converted(to: .celsius).value)
}

func dateToTimeString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a h시"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func dateToDayString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M.dd"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func precipitationToKoreanString(_ precipitation: String) -> String {
    switch precipitation {
    case "none" :
        return "없음"
    case "hail" :
        return "우박"
    case "mixed" :
        return "혼합강우"
    case "rain" :
        return "비"
    case "sleet" :
        return "진눈깨비"
    case "snow" :
        return "눈"
    default:
        return "결과 없음"
    }
}
func precipitationChanceDoubleToPercentage(precipitationChance: Double) -> String {
    return "\(Int(precipitationChance * 100))%"
}

func convertToKoreanWindDirection(_ compassDirection: String) -> String {
    switch compassDirection {
    case "north" :
        return "북풍"
    case "northNortheast" :
        return "북북동풍"
    case "northeast" :
        return "북동풍"
    case "eastNortheast" :
        return "동북동풍"
    case "east" :
        return "동풍"
    case "eastSoutheast" :
        return "동남풍"
    case "southeast" :
        return "남동풍"
    case "southSoutheast" :
        return "남남동풍"
    case "south" :
        return "남풍"
    case "southSouthwest" :
        return "남남서풍"
    case "southwest" :
        return "남서풍"
    case "westSouthwest" :
        return "서남서풍"
    case "west" :
        return "서풍"
    case "westNorthwest" :
        return "서북서풍"
    case "northwest" :
        return "북서풍"
    case "northNorthwest" :
        return "북북서"
    default:
        return "알 수 없음"
    }
}

func unitWindSpeedToString(windSpeed: Measurement<UnitSpeed>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .providedUnit
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 1
    
    return measurementFormatter.string(from: windSpeed)
}

func visibilityUnitLengthToString(visibility: Measurement<UnitLength>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .naturalScale
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 0

    return measurementFormatter.string(from: visibility)
}

func precipitationUnitLengthToString(precipitationAmount: Measurement<UnitLength>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .providedUnit
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 1
    
    return measurementFormatter.string(from: precipitationAmount)
}
