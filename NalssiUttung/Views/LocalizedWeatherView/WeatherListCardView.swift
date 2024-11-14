//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import CoreLocation
import SwiftUI

struct WeatherListCardView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherLocationManager = WeatherLocationManager()
    
    let locationInfo: LocationInfo?
    // TODO: - isCurrentLocation 없앨 수 있을지 고민해 보기.
    let isCurrentLocation: Bool
    
    var body: some View {
        Group {
            if let currentWeather = weatherLocationManager.currentWeather {
                WeatherCardLayout(currentWeather: currentWeather,
                                  viewOrigin: .list,
                                  address: locationInfo?.address ?? locationManager.currentAddress)
            } else {
                WeatherCardLayout(currentWeather: CurrentWeather.placeholder,
                                  viewOrigin: .list, address: "")
                    .redacted(reason: .placeholder)
            }
        }
        .padding(.bottom, 15.responsibleHeight)
        .task {
            if let locationInfo = locationInfo {
                weatherLocationManager.selectedLocation = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
                print("selectedLocation is \(weatherLocationManager.selectedLocation!)")
            } else {
                print("No location Info")
            }
            await weatherLocationManager.fetchWeather(with: .current)
        }
    }
}

#Preview {
    WeatherListCardView(weatherLocationManager: WeatherLocationManager(), locationInfo: LocationInfo.Data[0], isCurrentLocation: true)
        .environmentObject(ToolbarViewModel())
}
