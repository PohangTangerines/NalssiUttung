//
//  RealTimeWeather.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import SwiftUI

struct RealTimeWeather: View {
    @Binding var weather: Weather
    
    var body: some View {
        ZStack {
            Color.seaSky
                .ignoresSafeArea()
            HStack {
                Spacer()
                Image("halla")
            }
            .padding(.top, 380.0)
            HStack(spacing: 0.0) {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Text("\(weather.temperature)°")
                            .font(.system(size:80))
                            .padding(.bottom, -15.0)
                        Text("\(weather.condition)")
                            .font(.system(size:26))
                    }
                    .padding(.bottom, 21)
                    Text("최고 \(weather.highTemperature)° | 최저 \(weather.lowTemperature)°")
                        .font(.system(size:20))
                        .padding(.bottom, 24.0)
                    Text("\(weather.weatherMessage)")
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .font(.system(size:26))
                }
                Spacer()
            }
            .padding(.leading, 20.0)
        }
    }
}

struct RealTimeWeather_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeWeather(weather: .constant(Weather.sampleData[0]))
    }
}
