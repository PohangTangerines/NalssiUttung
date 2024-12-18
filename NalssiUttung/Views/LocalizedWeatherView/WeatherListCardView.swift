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
    @StateObject var weatherManager = WeatherManager()
    
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    
    var locationInfo: LocationInfo?
    
    var body: some View {
        Group {
            if let currentWeather = weatherManager.currentWeather {
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
                localizedWeatherViewModel.selectedLocation = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
                print("selectedLocation is \(localizedWeatherViewModel.selectedLocation!)")
            } else {
                print("No location Info")
            }
            await weatherManager.fetchWeather(with: .current)
        }
    }
}

#Preview {
    WeatherListCardView(weatherManager: WeatherManager(), localizedWeatherViewModel: LocalizedWeatherViewModel(), locationInfo: LocationInfo.Data[0])
        .environmentObject(ToolbarViewModel())
}
