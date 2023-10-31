//
//  MainScrolledView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct MainScrolledView: View {
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var weeklyWeatherData: WeeklyWeatherData?
    @Binding var detailedWeatherData: DetailedWeatherData?

    var body: some View {
        VStack(spacing: 0) {            
            LocationCardScrolled(weatherBoxData: $weatherBoxData)
            WeeklyWeatherView(weeklyWeatherData: $weeklyWeatherData)
                .padding(.top, 27)
                .padding(.bottom, 30)
            DetailedWeatherView(detailedWeatherData: $detailedWeatherData)
            Spacer()
        }.padding(.horizontal, 15).background(Color.seaSky)
    }
}
