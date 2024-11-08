//
//  MainScrolledView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct CurrentWeatherDetailView: View {
    @ObservedObject var weatherManager: WeatherManager
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        if let currentWeather = weatherManager.currentWeather {
            VStack(spacing: 0) {
                WeatherCardLayout(currentWeather: currentWeather, viewOrigin: .main)
                    .padding(.bottom, 30.responsibleHeight)

                WeeklyWeatherView(weatherManager: weatherManager)
                    .padding(.bottom, 100.responsibleHeight)
                
                DetailedWeatherView(weatherManager: weatherManager)
                    .padding(.bottom, 30.responsibleHeight)
                
                // MARK: 날씨삼춘 알아보기 - 만든사람들, WeatherKit 출처
                NavigationLink(destination: InformationView()) {
                    HStack {
                        Text("\(Image(systemName: "info.circle.fill"))")
                        Text("날씨삼춘 알아보기").underline()
                    }
                    .foregroundStyle(Color.darkChacoal)
                    .font(.IMHyemin(.caption2))
                    .padding(.bottom, 15.responsibleHeight)
                }
            }
            .padding(.top, -35.responsibleHeight)
            .padding(.horizontal, 15.responsibleWidth)
        }
    }
}
