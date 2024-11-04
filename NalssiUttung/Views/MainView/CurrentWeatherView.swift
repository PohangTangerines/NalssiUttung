//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        if let currentWeather = weatherManager.currentWeather {
            CurrentWeatherInfo(weather: currentWeather)
            CommentAndCharacter(weather: currentWeather)
            DailyWeatherView(weatherManager: weatherManager)
            ScrollDownIndicator(viewModel: viewModel)
        }
    }
}

struct CurrentWeatherInfo: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text("\(weather.temperature) ")
                    .font(.IMHyemin(.largeTitle2))
                    .tracking(-(Font.FontSize.largeTitle.rawValue * 0.07))
                Text("°")
                    .font(.IMHyemin(.largeTitle))
                    .padding(.leading, -(Font.FontSize.largeTitle2.rawValue * 0.5))
                Text("\(weather.weatherCondition.description)")
                    .font(.IMHyemin(.title))
                    .padding(.bottom, 13)
                    .padding(.leading, -30)
                Spacer()
            }
            .padding(.bottom, 5.responsibleHeight)
            HStack {
                Text("최고 \(weather.highestTemperature)° | 최저 \(weather.lowestTemperature)°")
                    .font(.pretendardMedium(.body))
                Spacer()
            }
            .padding(.bottom, 15.responsibleHeight)
        }
        .padding(.top, -40.responsibleHeight)
    }
}

struct CommentAndCharacter: View {
    let weather: CurrentWeather
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(weather.comment)")
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
                    AnimatedGifView(gifName: weather.gifName)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280.responsibleHeight)
                }
            }
        }
        .frame(height: 340.responsibleHeight)
    }
}

struct ScrollDownIndicator: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Image(systemName: "chevron.down")
            .resizable()
            .scaledToFit()
            .frame(height: 10.responsibleWidth)
            .foregroundStyle(.black)
            .background {
                Circle()
                    .frame(width: 40.responsibleWidth, height: 40.responsibleWidth)
                    .foregroundStyle(viewModel.canTransition ? Color.accentBlue: Color.clear)
            }
            .padding(.bottom, 21.responsibleHeight)
    }
}
