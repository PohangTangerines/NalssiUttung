//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    @Binding var canTransition: Bool
    @State private var gifName: String = "clearCharacter"
    
    var body: some View {
        if let currentWeather = weatherManager.currentWeather, let dailyForecast = weatherManager.dailyForecast {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    tempConditionRow
                        .padding(.bottom, 5.responsibleHeight)
                    HStack {
                        Text("최고 \(currentWeather.highestTemperature)° | 최저 \(currentWeather.lowestTemperature)°")
                            .font(.pretendardMedium(.body))
                        Spacer()
                    }
                    .padding(.bottom, 15.responsibleHeight)
                }
                ZStack {
                    // MARK: - 날씨 멘트
                    VStack {
                        HStack {
                            Text("\(currentWeather.weatherCondition.comment(sunrise: dailyForecast.sunrise, sunset: dailyForecast.sunset))")
                                .font(.IMHyemin(.title))
                                .IMHyeminLineHeight(.title, lineHeight: 40)
                            Spacer()
                        }
                        Spacer()
                    }
                    // MARK: - 날씨 캐릭터
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            AnimatedGifView(gifName: $gifName)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 280.responsibleHeight)
                        }
                    }.onAppear {
                        gifName = currentWeather.weatherCondition.character(sunrise: dailyForecast.sunrise, sunset: dailyForecast.sunset)
                        print(gifName)
                    }
                }.frame(height: 340.responsibleHeight)
                VStack {
                    DailyWeatherView(weatherManager: weatherManager)
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10.responsibleWidth)
                        .foregroundStyle(.black)
                        .background {
                            Circle()
                                .frame(width: 40.responsibleWidth, height: 40.responsibleWidth)
                                .foregroundStyle(Color.accentBlue)
                        }
                        .padding(.bottom, 21.responsibleHeight)
                }
            }
            .padding(.top, -40.responsibleHeight)
        }
    }
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            if let currentWeather = weatherManager.currentWeather {
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
        }
    }
}
