//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct RealTimeWeatherView: View {
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var dailyWeatherData: DailyWeatherData?
    @Binding var canTransition: Bool
    @Binding var isModalVisible: Bool
    #warning("isModal 관련 기기대응 추후 수정 요망")
    let isModal: Bool
    @State private var gifName: String = "clearCharacter"
    
    var body: some View {
        if let weatherBoxData = weatherBoxData, let dailyWeatherData = dailyWeatherData {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    tempConditionRow
                        .padding(.bottom, isModal ? 5.responsibleHeight : 10.responsibleHeight)
                    HStack {
                        Text("최고 \(weatherBoxData.highestTemperature)° | 최저 \(weatherBoxData.lowestTemperature)°")
                            .font(.pretendardMedium(.body))
                        Spacer()
                    }
                    .padding(.bottom, isModal ? 9.responsibleHeight : 18.responsibleHeight)
                }
                ZStack {
                    // MARK: - 날씨 멘트
                    VStack {
                        HStack {
                            Text("\(weatherBoxData.weatherCondition.weatherComment(weatherData: dailyWeatherData))")
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
                        gifName = weatherBoxData.weatherCondition.weatherCharacter(weatherData: dailyWeatherData)
                        print(gifName)
                    }
                }.frame(height: 340.responsibleHeight)
                VStack {
                    DailyWeatherView(dailyWeatherData: $dailyWeatherData)
                    if isModalVisible {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 10.responsibleWidth)
                            .foregroundColor(.black)
                            .background {
                                Circle()
                                    .frame(width: 40.responsibleWidth, height: 40.responsibleWidth)
                                    .foregroundColor(canTransition ? Color.accentBlue : Color.clear)
                            }
                            .padding(.bottom, 21.responsibleHeight)
                    }
                }
            }
           
        }
    }
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            if let weatherBoxData = weatherBoxData {
                Text("\(weatherBoxData.currentTemperature) ")
                    .font(.IMHyemin(.largeTitle2))
                    .tracking(-(Font.FontSize.largeTitle.rawValue * 0.07))
                Text("°")
                    .font(.IMHyemin(.largeTitle))
                    .padding(.leading, -(Font.FontSize.largeTitle2.rawValue * 0.5))
                Text("\(weatherBoxData.weatherCondition.weatherString())")
                    .font(.IMHyemin(.title))
                    .padding(.bottom, 13)
                    .padding(.leading, -30)
                Spacer()
            }
        }
    }
}
