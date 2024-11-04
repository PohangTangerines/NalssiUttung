//
//  LocationCardScrolled.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/28/24.
//
import SwiftUI

// TODO: - WeatherCard 재활용하기
struct LocationCardScrolled: View {
    @ObservedObject var weatherManager: WeatherManager
    
    @State var dateString: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            if let currentWeather = weatherManager.currentWeather {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Date
                    Text("\(dateString)")
                        .font(.pretendardSemibold(.caption))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Image(currentWeather.weatherCondition.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60.responsibleWidth)
                            .padding(.trailing, 12.responsibleWidth)
                            .padding(.top, 9.responsibleHeight)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // MARK: 온도 및 날씨
                            HStack(spacing: 0) {
                                Text("\(currentWeather.temperature)°")
                                    .font(.IMHyemin(.title2))
                                    .tracking(-(Font.FontSize.title2.rawValue * 0.07))
                                Text(currentWeather.weatherCondition.description)
                                    .font(.IMHyemin(.title2))
                            }.padding(.bottom, 3.responsibleHeight)
                            
                            // MARK: 최저 최고 온도
                            Text("최저 \(currentWeather.lowestTemperature)° | 최고 \(currentWeather.highestTemperature)°")
                                .font(.pretendardMedium(.footnote))
                        }.padding(.bottom, 18.responsibleHeight)
                            .padding(.top, 12.responsibleHeight)
                        Spacer()
                    }
                }
                .padding(.top, 10.responsibleHeight)
                .padding(.leading, 15.responsibleWidth)
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }.task {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "M월 d일 E요일"
            self.dateString = dateFormatter.string(from: today)
        }.overlay(
            RoundedRectangle(cornerRadius: 9)
                .strokeBorder(Color.black, lineWidth: 1.5)
                .contentShape(Rectangle())
        )
    }
}
