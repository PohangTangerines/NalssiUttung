//
//  NalssiUttungApp.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/05.
//

import SwiftUI
import WeatherKit

@main
struct NalssiUttungApp: App {
    @ObservedObject var locationManager = LocationManager.shared
    let weatherManager = WeatherService.shared
    
    @State var weatherBoxData: WeatherBoxData?
    @State var dailyWeatherData: DailyWeatherData?
    @State var weeklyWeatherData: WeeklyWeatherData?
    @State var detailedWeatherData: DetailedWeatherData?

    
    var body: some Scene {
        WindowGroup {
            DetailedWeatherView(detailedWeatherData: $detailedWeatherData)
                .task {
                    if let location = locationManager.location {
                        if let weather = await weatherManager.getWeather(location: location) {
                            self.weatherBoxData = weatherManager.getWeatherBoxData(location: location, weather: weather)
                            self.dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
                            self.weeklyWeatherData = weatherManager.getWeeklyWeatherData(weather: weather)
                            self.detailedWeatherData = weatherManager.getDetailedWeatherData(weather: weather)
                    }
                }
            }
        }
    }
}
