//
//  DetailedWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import SwiftUI
import WeatherKit

struct DetailedWeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        VStack(spacing: 0) {
            if let detailedWeather = weatherManager.detailedWeather {
                // MARK: 상세 날씨 구분선
                TextDivider(text: "상세 날씨")
                    .padding(.bottom, 15.responsibleHeight)
                
                GeometryReader { geometry in
                    // MARK: 강수량 & 바람 & 가시거리
                    HStack(spacing: 0) {
                        DetailBox(title: "강수량",
                                  imageName: "precipitation",
                                  detailString: "\(detailedWeather.precipitation)",
                                  valueString: "\(detailedWeather.precipitationAmount)")
                        .frame(maxWidth: geometry.size.width/3)
                        Rectangle()
                            .background(Color.black)
                            .frame(width: 1, height: 132.responsibleHeight).cornerRadius(10)
                            .padding(.horizontal, 5.responsibleWidth)
                        DetailBox(title: "바람",
                                  imageName: "windy",
                                  detailString: "\(detailedWeather.windDirection)",
                                  valueString: "\(detailedWeather.windSpeed)")
                        .frame(maxWidth: geometry.size.width/3)
                        Rectangle()
                            .background(Color.black)
                            .frame(width: 1, height: 132.responsibleHeight).cornerRadius(10)
                            .padding(.horizontal, 5.responsibleWidth)
                        DetailBox(title: "가시거리",
                                  imageName: "visibility",
                                  detailString: " ",
                                  valueString: "\(detailedWeather.visibility)")
                        .frame(maxWidth: geometry.size.width/3)
                    }
                }
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 172.responsibleHeight)
        .padding(.bottom, 30.responsibleHeight)
    }
    
    // MARK: DetailedWeather Box
    private struct DetailBox: View {
        let title: String
        let imageName: String
        let detailString: String
        let valueString: String
        
        var body: some View {
            VStack(spacing: 0) {
                Text(title)
                    .lineLimit(1)
                    .font(.pretendardMedium(.caption))
                    .padding(.bottom, 6)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:36)
                    .padding(.bottom, 6)
                Text(detailString)
                    .lineLimit(1)
                    .font(.pretendardMedium(.footnote))
                    .padding(.bottom, 6)
                Text(valueString)
                    .lineLimit(1)
                    .font(.pretendardMedium(.caption))
            }
        }
    }
}

