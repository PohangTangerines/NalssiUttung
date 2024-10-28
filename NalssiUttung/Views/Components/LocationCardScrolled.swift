//
//  LocationCardScrolled.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/28/24.
//
import SwiftUI

struct LocationCardScrolled: View {
    @Binding var weatherBoxData: WeatherBoxData?
    
    @State var dateString: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            if let weatherBoxData = weatherBoxData {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Date
                    Text("\(dateString)")
                        .font(.pretendardSemibold(.caption))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Image(weatherBoxData.weatherCondition.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60.responsibleWidth)
                            .padding(.trailing, 12.responsibleWidth)
                            .padding(.top, 9.responsibleHeight)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // MARK: 온도 및 날씨
                            HStack(spacing: 0) {
                                Text("\(weatherBoxData.currentTemperature)°")
                                    .font(.IMHyemin(.title2))
                                    .tracking(-(Font.FontSize.title2.rawValue * 0.07))
                                Text(weatherBoxData.weatherCondition.getWeatherString())
                                    .font(.IMHyemin(.title2))
                                //                                    .padding(.leading, -(Font.DEFontSize.title2.rawValue * 0.3))
                            }.padding(.bottom, 3.responsibleHeight)
                            
                            // MARK: 최저 최고 온도
                            Text("최저 \(weatherBoxData.lowestTemperature)° | 최고 \(weatherBoxData.highestTemperature)°")
                                .font(.pretendardMedium(.footnote))
                        }.padding(.bottom, 18.responsibleHeight)
                            .padding(.top, 12.responsibleHeight)
                        Spacer()
                    }
                }.padding(.top, 15.responsibleHeight)
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
