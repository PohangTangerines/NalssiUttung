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
    @StateObject var weatherManager = WeatherManager()

    var locationInfo: LocationInfo?
    
    var body: some View {
        Group {
            if let currentWeather = weatherManager.currentWeather {
                WeatherCardLayout(currentWeather: currentWeather,
                                  viewOrigin: .list,
                                  address: locationInfo?.address ?? LocationManager.shared.currentAddress)
            } else {
                WeatherCardLayout(currentWeather: CurrentWeather.placeholder,
                                  viewOrigin: .list, address: "")
                    .redacted(reason: .placeholder)
            }
        }
        .padding(.bottom, 15.responsibleHeight)
        .task {
            /// 선택된 위치가 없으면(LocalizedWeatherListView로부터 LocationInfo를 받지 못하면) 현재 위치 날씨 정보 로드.
            /// 선택된 위치가 있으면 선택된 위치 날씨 정보 로드.
            guard let locationInfo = locationInfo else {
                await weatherManager.fetchWeather(with: .current)
                return
            }
            
            let selectedLocation = CLLocation(latitude: locationInfo.coordinate.latitude, longitude: locationInfo.coordinate.longitude)
            await weatherManager.fetchWeather(with: .current, for: selectedLocation)
        }
    }
}

#Preview {
    WeatherListCardView(locationInfo: LocationInfo.Data[0])
        .environmentObject(ToolbarViewModel())
}
