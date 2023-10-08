//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct RealTimeWeatherView: View {
    @Binding var dailyWeatherData: DailyWeatherData?
    @Binding var canTransition: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            tempConditionRow
                .padding(.bottom, 10)
            // TODO: tempConditionRow ~ 최고 최저 온도 사이 padding값 물어보기. (임시값 10)
            
            HStack {
                Text("최고 \(33)° | 최저 \(24)°")
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
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            Text("24 ")
                .font(.IMHyemin(.largeTitle2))
                .tracking(-(Font.DEFontSize.largeTitle.rawValue * 0.1))
            Text("°")
                .font(.IMHyemin(.largeTitle))
                .padding(.leading, -(Font.DEFontSize.largeTitle2.rawValue * 0.5))
            Text("맑음")
                .font(.IMHyemin(.title))
                .padding(.bottom, 13)
                .padding(.leading, -30)
            Spacer()
        }
    }
    
}
