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
                .padding(.top, 27.responsibleHeight)
                .padding(.bottom, 20.responsibleHeight)
            
            Spacer()
            DetailedWeatherView(detailedWeatherData: $detailedWeatherData)
                .padding(.bottom, 30.responsibleHeight)
//            Spacer()
            
            // MARK: 날씨삼춘 알아보기 - 만든사람들, WeatherKit 출처
            NavigationLink(destination: InformationView()) {
                HStack {
                    Text("\(Image(systemName: "info.circle.fill"))")
                    Text("날씨삼춘 알아보기").underline()
                }
            }.foregroundColor(Color.darkChacoal)
                .font(.IMHyemin(.caption2))
                .padding(.bottom, 15.responsibleHeight)
            
        }.padding(.horizontal, 15.responsibleWidth)
            .background(Color.seaSky)
    }
}
