//
//  MainInitView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct MainInitView: View {
    @Binding var dailyWeatherData: DailyWeatherData?
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var canTransition: Bool
    
    var body: some View {
        if let dailyWeatherData = dailyWeatherData, let weatherBoxData = weatherBoxData {
            ZStack {
                VStack(spacing: 0) {
                    tempConditionRow
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("최고 \(weatherBoxData.lowestTemperature)° | 최저 \(weatherBoxData.highestTemperature)°")
                            .font(.pretendardMedium(.body))
                        Spacer()
                    }.padding(.bottom, 18)
                    
                    ZStack {
                        VStack {
                            HStack {
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
        } else {
            // TODO: 로딩화면
        }
    }
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            Text("\(weatherBoxData!.currentTemperature) ")
                .font(.IMHyemin(.largeTitle2))
                .tracking(-(Font.DEFontSize.largeTitle.rawValue * 0.1))
            Text("°")
                .font(.IMHyemin(.largeTitle))
                .padding(.leading, -(Font.DEFontSize.largeTitle2.rawValue * 0.5))
            Text("\(weatherBoxData!.weatherCondition.weatherString())")
                .font(.IMHyemin(.title))
                .padding(.bottom, 13)
                .padding(.leading, -30)
            Spacer()
        }
    }
    
}
