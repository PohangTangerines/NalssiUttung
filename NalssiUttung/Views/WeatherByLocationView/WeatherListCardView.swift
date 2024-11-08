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
    
    let address: String
    let isCurrentLocation: Bool
    let mode: WeatherDisplayMode
    
    var body: some View {
        Group {
            if let currentWeather = weatherManager.currentWeather {
                WeatherCardLayout(currentWeather: currentWeather, viewOrigin: .list, address: address, isCurrentLocation: isCurrentLocation)
            } else {
                WeatherCardLayout(currentWeather: CurrentWeather.placeholder, viewOrigin: .list, address: address, isCurrentLocation: isCurrentLocation)
                    .redacted(reason: .placeholder)
            }
        }
        .onTapGesture {
            // TODO: - 강제 언래핑 변경, updatedLocation이 언제 nil이 되는지 다시 확인해보기
            let updatedLocation = locationManager.findCoordinates(address: address)
            locationManager.selectedLocation = updatedLocation
            toolbarViewModel.isModalPresented = true
        }
        .sheet(isPresented: $toolbarViewModel.isModalPresented) {
            MainView(mode: mode)
                .onDisappear {
                    locationManager.selectedLocation = nil
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
    WeatherListCardView(weatherManager: WeatherManager(), address: "제주시 애월읍", isCurrentLocation: true, mode: .modal)
}
