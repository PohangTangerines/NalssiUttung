//
//  MainScrolledView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct CurrentWeatherDetailView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        if let currentWeather = weatherManager.currentWeather,
           let weeklyForecast = weatherManager.weeklyForecast,
           let detailedForecast = weatherManager.detailedForecast {
            VStack(spacing: 0) {
                WeatherCardLayout(currentWeather: currentWeather, viewOrigin: .main)
                    .padding(.bottom, 30.responsibleHeight)

                WeeklyForecastView(weeklyForecast: weeklyForecast)
                
                DetailedForecastView(detailedForecast: detailedForecast)
                
                NavigationLink(destination: InformationView()) {
                    InformationLabel()
                }
            }
            .padding(.top, -35.responsibleHeight)
        } else {
            Text("날씨를 불러오는 중입니다...")
        }
    }
}

struct InformationLabel: View {
    var body: some View {
        HStack {
            Text("\(Image(systemName: "info.circle.fill"))")
            Text("날씨삼춘 알아보기").underline()
        }
        .foregroundStyle(Color.darkChacoal)
        .font(.IMHyemin(.caption2))
        .padding(.bottom, 15.responsibleHeight)
    }
}
