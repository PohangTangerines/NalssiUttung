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
        VStack(spacing: 0) {
            LocationCardScrolled(weatherManager: weatherManager)
            WeeklyWeatherView(weatherManager: weatherManager)
                .padding(.top, 27.responsibleHeight)
                .padding(.bottom, 20.responsibleHeight)
            
            Spacer()
            
            DetailedWeatherView(weatherManager: weatherManager)
                .padding(.bottom, 30.responsibleHeight)
            
            // MARK: 날씨삼춘 알아보기 - 만든사람들, WeatherKit 출처
            NavigationLink(destination: InformationView()) {
                HStack {
                    Text("\(Image(systemName: "info.circle.fill"))")
                    Text("날씨삼춘 알아보기").underline()
                }
                .foregroundColor(Color.darkChacoal)
                .font(.IMHyemin(.caption2))
                .padding(.bottom, 15.responsibleHeight)
            }
        }
        .padding(.top, -25.responsibleHeight)
        .padding(.horizontal, 15.responsibleWidth)
        .background(Color.seaSky)
    }
}
