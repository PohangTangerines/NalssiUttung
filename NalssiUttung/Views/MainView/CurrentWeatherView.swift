//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    @ObservedObject var weatherLocationManager: WeatherLocationManager
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        if let currentWeather = weatherLocationManager.currentWeather,
            let dailyForecast = weatherLocationManager.dailyForecast {
            VStack {
                CurrentWeatherInfo(currentWeather: currentWeather)
                CommentAndCharacter(currentWeather: currentWeather)
                DailyForecastView(dailyForecast: dailyForecast)
                ScrollDownIndicator(viewModel: viewModel)
            }
        } else {
           Text("날씨를 불러오는 중입니다...")
        }
    }
}

struct CurrentWeatherInfo: View {
    let currentWeather: CurrentWeather
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text("\(currentWeather.temperature) ")
                    .font(.IMHyemin(.largeTitle2))
                    .tracking(-(Font.FontSize.largeTitle.rawValue * 0.07))
                Text("°")
                    .font(.IMHyemin(.largeTitle))
                    .padding(.leading, -(Font.FontSize.largeTitle2.rawValue * 0.5))
                Text("\(currentWeather.weatherCondition.description)")
                    .font(.IMHyemin(.title))
                    .padding(.bottom, 13)
                    .padding(.leading, -30)
                Spacer()
            }
            .padding(.bottom, 5.responsibleHeight)
            HStack {
                Text("최고 \(currentWeather.highestTemperature)° | 최저 \(currentWeather.lowestTemperature)°")
                    .font(.pretendardMedium(.body))
                Spacer()
            }
            .padding(.bottom, 15.responsibleHeight)
        }
        .padding(.top, -40.responsibleHeight)
    }
}

struct CommentAndCharacter: View {
    let currentWeather: CurrentWeather
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(currentWeather.comment)")
                        .font(.IMHyemin(.title))
                        .IMHyeminLineHeight(.title, lineHeight: 40)
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AnimatedGifView(gifName: currentWeather.gifName)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280.responsibleHeight)
                }
            }
        }
        .frame(height: 340.responsibleHeight)
    }
}
