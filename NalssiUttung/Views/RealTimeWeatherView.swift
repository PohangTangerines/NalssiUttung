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
    
    var body: some View {
        if let weatherBoxData = weatherBoxData {
            VStack(spacing: 0) {
                tempConditionRow
                    .padding(.bottom, 10)
                
                HStack {
                    Text("최고 \(weatherBoxData.highestTemperature)° | 최저 \(weatherBoxData.lowestTemperature)°")
                        .font(.pretendardMedium(.body))
                    Spacer()
                }.padding(.bottom, 18)
                
                ZStack {
                    VStack {
                        HStack {
                            // TODO: 텍스트 교체
                            Text("일교차 크난\n고뿔 들리지 않게\n조심합서!")
                                .font(.IMHyemin(.title))
                                .IMHyeminLineHeight(.title, lineHeight: 40)
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer().frame(height: 50)
                        HStack {
                            Spacer()
                            Image("halla")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280)
                        }
                    }
                }
                
                DailyWeatherView(dailyWeatherData: $dailyWeatherData)
                
                if isModalVisible {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10)
                        .foregroundColor(.black)
                        .background {
                            Circle().frame(width: 40, height: 40)
                                .foregroundColor(canTransition ? Color.accentBlue : Color.clear)
                        }
                        .padding(.top, 42).padding(.bottom, 21)
                }
            }
        }
    }
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            if let weatherBoxData = weatherBoxData {
                Text("\(weatherBoxData.currentTemperature) ")
                    .font(.IMHyemin(.largeTitle2))
                    .tracking(-(Font.DEFontSize.largeTitle.rawValue * 0.07))
                Text("°")
                    .font(.IMHyemin(.largeTitle))
                    .padding(.leading, -(Font.DEFontSize.largeTitle2.rawValue * 0.5))
                Text("\(weatherBoxData.weatherCondition.weatherString())")
                    .font(.IMHyemin(.title))
                    .padding(.bottom, 13)
                    .padding(.leading, -30)
                Spacer()
            }
        }
    }
}
