//
//  MainScrolledView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct MainScrolledView: View {
    @State private var isPresentInformationView = false
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var weeklyWeatherData: WeeklyWeatherData?
    @Binding var detailedWeatherData: DetailedWeatherData?

    var body: some View {
        VStack(spacing: 0) {            
            LocationCardScrolled(weatherBoxData: $weatherBoxData)
            WeeklyWeatherView(weeklyWeatherData: $weeklyWeatherData)
                .padding(.top, 27)
                .padding(.bottom, 20)
            DetailedWeatherView(detailedWeatherData: $detailedWeatherData)
            Spacer()
            
            // MARK: 날씨삼춘 알아보기 - 만든사람들, WeatherKit 출처
            HStack {
                Text("\(Image(systemName: "info.circle.fill"))")
                Text("날씨삼춘 알아보기").underline()
            }.navigationDestination(isPresented: $isPresentInformationView, destination: {
                // Navigation
            }).foregroundColor(Color.darkChacoal)
                .font(.IMHyemin(.caption2))
                .padding(.bottom, 15)
            
        }.padding(.horizontal, 15).background(Color.seaSky)
    }
}
