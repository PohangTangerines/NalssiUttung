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
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    let locationInfo: LocationInfo?
    let isCurrentLocation: Bool
    
    var body: some View {
        Group {
            if let currentWeather = weatherManager.currentWeather {
                WeatherCardLayout(currentWeather: currentWeather, viewOrigin: .list, address: locationInfo?.address, isCurrentLocation: isCurrentLocation)
            } else {
                WeatherCardLayout(currentWeather: CurrentWeather.placeholder, viewOrigin: .list, address: locationInfo?.address, isCurrentLocation: isCurrentLocation)
                    .redacted(reason: .placeholder)
            }
        }
        .padding(.bottom, 15.responsibleHeight)

        .onTapGesture {
            if let locationInfo = locationInfo {
                let updatedLocation = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
                locationManager.selectedLocation = updatedLocation
            } else {
                print("No location info")
            }
            if !toolbarViewModel.isModalPresented { // 현재 true가 아닌 경우만 설정
                toolbarViewModel.isModalPresented = true
            }
        }
        .task {
            if isCurrentLocation {
                await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .current)
            } else {
                if let locationInfo = locationInfo {
                    let location = CLLocation(latitude: locationInfo.coordinate.latitude,
                                              longitude: locationInfo.coordinate.longitude)
                    await weatherManager.fetchWeather(for: location, with: .current)
                }
            }
        }
    }
}

#Preview {
    WeatherListCardView(weatherManager: WeatherManager(), locationInfo: LocationInfo.Data[0], isCurrentLocation: true)
        .environmentObject(ToolbarViewModel())
}
