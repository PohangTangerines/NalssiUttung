//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct WeatherListCardView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    let address: String
    let isCurrentLocation: Bool
    
    var body: some View {
        Group {
            if let currentWeather = weatherManager.currentWeather {
                WeatherCardLayout(currentWeather: currentWeather, viewOrigin: .list, address: address, isCurrentLocation: isCurrentLocation)
            } else {
                WeatherCardLayout(currentWeather: CurrentWeather.placeholder, viewOrigin: .list, address: address, isCurrentLocation: isCurrentLocation)
                    .redacted(reason: .placeholder)
            }
        }
        .task {
            // TODO: - UserDefault에 저장하는 값 CLLocation(longitude, latitude)로 바꾸고 findCoordiates 제거
            if isCurrentLocation {
                await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .current)
            } else {
                if let location = locationManager.findCoordinates(address: address) {
                    await weatherManager.fetchWeather(for: location, with: .current)
                }
            }
        }
    }
}

#Preview {
    WeatherListCardView(weatherManager: WeatherManager(), address: "제주시 애월읍", isCurrentLocation: true)
}
