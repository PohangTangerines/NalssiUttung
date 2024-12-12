//
//  WeatherManager.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/22/24.
//

import CoreLocation
import SwiftUI
import WeatherKit

class WeatherLocationManager: ObservableObject {
    var selectedLocation: CLLocation? {
        didSet {
            Task {
                await fetchWeather(with: .all)
                await updateSelectedAddress()
            }
        }
    }
    
    @Published var selectedAddress: String?
    var weather: Weather?
    
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: DailyForecast?
    @Published var weeklyForecast: WeeklyForecast?
    @Published var detailedForecast: DetailedForecast?
    
    private let updateState = UpdateState()
    
    @MainActor
    private func updateSelectedAddress() async {
        guard let selectedLocation else { return }
        
        do {
            selectedAddress = try await LocationManager.shared.getAddress(from: selectedLocation)
        } catch {
            print("주소 변환 오류: \(error)")
        }
    }
    
    /// 선택한 location이 있는 경우에는 선택된 location을 바탕으로 날씨를 업데이트합니다.
    /// 없는 경우에는 현재 위치 바탕으로 날씨를 업데이트합니다.
    func fetchWeather(with type: WeatherUpdateType) async {
        
        guard await updateState.startUpdating() else { return }
        
        defer {
            Task {
                await updateState.stopUpdating()
            }
        }
        
        if let selectedLocation = selectedLocation {
            print("선택된 위치\(selectedLocation)로 날씨 데이터를 가져옵니다.")
            
            do {
                self.weather = try await WeatherService.shared.weather(for: selectedLocation)
            } catch {
                print("현재 날씨 정보를 불러오는 데 실패했습니다.")
            }
        } else {
            print("현재 위치로 날씨 데이터를 가져옵니다.")
            
            await LocationManager.shared.updateCurrentLocation()

            guard let currentLocation = LocationManager.shared.currentLocation else {
                print("현재 위치를 업데이트하는 데 실패했습니다.")
                return
            }
            do {
                self.weather = try await WeatherService.shared.weather(for: currentLocation)
            } catch {
                print("현재 날씨 정보를 불러오는 데 실패했습니다.")
            }
        }
        
        await updateWeather(with: type)
    }
    
    @MainActor
    func updateWeather(with type: WeatherUpdateType) {
        switch type {
            
        case .all:
            self.updateCurrentWeather()
            self.updateDailyForecast()
            self.updateWeeklyForecast()
            self.updateDetailedForecast()
            
        case .current:
            self.updateCurrentWeather()
        }
        print("성공적으로 날씨 데이터를 업데이트했습니다.")
    }
    
    private func updateCurrentWeather() {
        guard let weather = weather else {
            print(CustomWeatherError.noFetchedWeatherData.localizedDescription)
            return
        }
        
        let currentTemperature = WeatherDataFormatter.celsiusTemperature(from: weather.currentWeather.temperature)
        
        let weatherCondition = weather.currentWeather.condition
        
        guard let first = weather.dailyForecast.forecast.first else {
            print(CustomWeatherError.noDailyForecast.localizedDescription)
            return
        }
        
        let lowestTemperature = WeatherDataFormatter.celsiusTemperature(from: first.lowTemperature)
        let highestTemperature = WeatherDataFormatter.celsiusTemperature(from: first.highTemperature)
        
        guard let sunrise = weather.dailyForecast.forecast.first?.sun.sunrise, let sunset = weather.dailyForecast.forecast.first?.sun.sunset else {
            
            print(CustomWeatherError.sunEventUnavailable.localizedDescription)
            return
        }
        
        let gifName = weatherCondition.character(sunrise: sunrise, sunset: sunset)
        let comment = weatherCondition.comment(sunrise: sunrise, sunset: sunset)
        
        self.currentWeather = CurrentWeather(temperature: currentTemperature,
                                             weatherCondition: weatherCondition,
                                             lowestTemperature: lowestTemperature,
                                             highestTemperature: highestTemperature,
                                             gifName: gifName,
                                             comment: comment)
    }
    
    private func updateDailyForecast() {
        guard let weather = weather else { return }
        
        let filteredHourlyForecast = weather.hourlyForecast.forecast.filter { hourlyforecast in
            (hourlyforecast.date.timeIntervalSinceNow/3600) > 0 && (hourlyforecast.date.timeIntervalSinceNow/3600) < 24
        }
        
        var hours: [DailyForecast.Hour] = []
        
        filteredHourlyForecast.forEach { hourlyForecast in
            let time = hourlyForecast.date
            let condition = hourlyForecast.condition
            
            let temperature = hourlyForecast.temperature
            let convertedTemperature = WeatherDataFormatter.celsiusTemperature(from: temperature)
            
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
        
        self.dailyForecast = DailyForecast(sunrise: sunrise,
                                           sunset: sunset,
                                           hours: hours)
    }
    
    private func updateWeeklyForecast() {
        guard let weather = weather else { return }
        
        let filteredDailyForecast = weather.dailyForecast.forecast.filter { dayWeather in
            (dayWeather.date.timeIntervalSinceNow/3600) > -24 && (dayWeather.date.timeIntervalSinceNow/3600) < 144
        }
        
        var days: [WeeklyForecast.Day] = []
        filteredDailyForecast.forEach { dailyForecast in
            let date = dailyForecast.date
            
            let day = WeatherDataFormatter.dayOfWeek(from: date)
            let convertedDate = WeatherDataFormatter.monthAndDay(from: date)
            
            let weatherCondition = dailyForecast.condition
            let lowestTemperature = WeatherDataFormatter.celsiusTemperature(from: dailyForecast.lowTemperature)
            let highestTemperature = WeatherDataFormatter.celsiusTemperature(from: dailyForecast.highTemperature)
            let precipitationChance = WeatherDataFormatter.precipitationProbability(from: dailyForecast.precipitationChance)
            
            days.append(WeeklyForecast.Day(day: day, date: convertedDate, weatherCondition: weatherCondition, lowestTemperature: lowestTemperature, highestTemperature: highestTemperature, precipitationChance: precipitationChance))
        }
        
        self.weeklyForecast = WeeklyForecast(days: days)
    }
    
    private func updateDetailedForecast() {
        guard let weather = weather else { return }
        
        let windDirection = weather.currentWeather.wind.compassDirection
        let convertedWindDirection = WeatherDataFormatter.koreanWindDirection(from: windDirection.rawValue)
        
        let windSpeed = weather.currentWeather.wind.speed
        let convertedWindSpeed = WeatherDataFormatter.windSpeed(from: windSpeed)
        
        // 좋음/꽤 좋음/매우 좋음 등으로 표현하는 가시거리 존재하지 않음.
        let visibility = weather.currentWeather.visibility
        let convertedVisibility = WeatherDataFormatter.visibility(from: visibility)
        
        // currentWeather에는 강수량이 존재하지 않아, hourlyForecase의 현재 시간 범위의 강수량을 사용.
        let hourlyForecast = weather.hourlyForecast.forecast.filter { hourlyForecast in (hourlyForecast.date.timeIntervalSinceNow / 3600) >= -1 && (hourlyForecast.date.timeIntervalSinceNow / 3600) < 0
        }.first!
        
        let precipitation = hourlyForecast.precipitation
        let convertedPrecipitation = WeatherDataFormatter.precipitationDescription(from: precipitation.rawValue)
        
        let precipitationAmount = hourlyForecast.precipitationAmount
        let convertedPrecipitationAmount = WeatherDataFormatter.precipitationAmount(from: precipitationAmount)
        
        self.detailedForecast = DetailedForecast(precipitation: convertedPrecipitation,
                                                 precipitationAmount: convertedPrecipitationAmount,
                                                 windDirection: convertedWindDirection,
                                                 windSpeed: convertedWindSpeed,
                                                 visibility: convertedVisibility)
    }
}
