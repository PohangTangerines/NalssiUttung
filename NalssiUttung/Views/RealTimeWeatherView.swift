//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import SwiftUI

struct RealTimeWeatherView: View {
    @Binding var realTimeWeather: RealTimeWeather
    
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
                        Text("\(realTimeWeather.temperature)°")
                            .font(.system(size:80))
                            .padding(.bottom, -15.0)
                        Text("\(realTimeWeather.condition)")
                            .font(.system(size:26))
                    }
                    .padding(.bottom, 21)
                    Text("최고 \(realTimeWeather.highTemperature)° | 최저 \(realTimeWeather.lowTemperature)°")
                        .font(.system(size:20))
                        .padding(.bottom, 24.0)
                    Text("\(realTimeWeather.weatherMessage)")
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

struct RealTimeWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeWeatherView(realTimeWeather: .constant(RealTimeWeather.sampleData[0]))
    }
}
