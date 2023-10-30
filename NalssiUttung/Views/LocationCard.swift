//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import SwiftUI

struct LocationCard: View {
    @Binding var weatherBoxData: WeatherBoxData?
    @State var location: String
    @Binding var isCurrentLocation: Bool

    var body: some View {
        HStack(spacing: 0) {
            if let weatherBoxData = weatherBoxData {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Date
                    HStack {
                        if isCurrentLocation {
                            Text("나의 위치")
                                .font(.pretendardSemibold(.caption))
                                .font(.system(size: 26))
                            Spacer()
                        }
                        Text("\(location)")
                            .font(.pretendardSemibold(.caption))
                            .padding(.trailing, 20)
                    }

                    HStack(alignment: .top, spacing: 0) {
                        Image("dayClear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .padding(.trailing, 12)
                            .padding(.top, 9)

                        VStack(alignment: .leading, spacing: 0) {
                            // MARK: 온도 및 날씨
                            HStack(spacing: 0) {
                                Text("\(weatherBoxData.currentTemperature) ")
                                    .font(.IMHyemin(.title2))
                                    .tracking(-(Font.DEFontSize.title2.rawValue * 0.1))
                                Text("° 흐림")
                                    .font(.IMHyemin(.title2))
                                    .padding(.leading, -(Font.DEFontSize.title2.rawValue * 0.3))
                            }.padding(.bottom, 3)

                            // MARK: 최저 최고 온도
                            Text("최저 \(weatherBoxData.lowestTemperature)° | 최고 \(weatherBoxData.highestTemperature)°")
                                .font(.pretendardMedium(.footnote))
                        }.padding(.bottom, 18).padding(.top, 12)

                        Spacer()
                    }
                }.padding(.top, 15).padding(.leading, 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .strokeBorder(Color.black, lineWidth: 1.5)
                )
                .onAppear() {
                    print("여기는 card 안임")
                    print("현재 온도: \(weatherBoxData.currentTemperature)°C")
                    print("최고 온도: \(weatherBoxData.highestTemperature)°C")
                    print("최저 온도: \(weatherBoxData.lowestTemperature)°C")
                    print("날씨 상태: \(weatherBoxData.weatherCondition)")
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
    }
}

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
                        Image("dayClear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .padding(.trailing, 12)
                            .padding(.top, 9)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // MARK: 온도 및 날씨
                            HStack(spacing: 0) {
                                Text("\(weatherBoxData.currentTemperature) ")
                                    .font(.IMHyemin(.title2))
                                    .tracking(-(Font.DEFontSize.title2.rawValue * 0.1))
                                Text("° 흐림")
                                    .font(.IMHyemin(.title2))
                                    .padding(.leading, -(Font.DEFontSize.title2.rawValue * 0.3))
                            }.padding(.bottom, 3)
                            
                            // MARK: 최저 최고 온도
                            Text("최저 \(weatherBoxData.lowestTemperature)° | 최고 \(weatherBoxData.highestTemperature)°")
                                .font(.pretendardMedium(.footnote))
                        }.padding(.bottom, 18).padding(.top, 12)
                        
                        Spacer()
                    }
                }.padding(.top, 15).padding(.leading, 15)

            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }.task {
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "M월 d일 E요일"
            self.dateString = dateFormatter.string(from: today)
        }
    }
}
