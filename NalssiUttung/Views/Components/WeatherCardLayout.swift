//
//  WeatherCardLayout.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI

struct WeatherCardLayout: View {
    let currentWeather: CurrentWeather
    let viewOrigin: ViewOrigin
    
    let address: String?
    let isCurrentLocation: Bool?
    
    init(currentWeather: CurrentWeather, viewOrigin: ViewOrigin, address: String? = nil, isCurrentLocation: Bool? = nil) {
        self.currentWeather = currentWeather
        self.viewOrigin = viewOrigin
        self.address = address
        self.isCurrentLocation = isCurrentLocation
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                switch viewOrigin {
                case .main:
                    Text(WeatherDataFormatter.monthDayAndDayOfWeek())
                        .font(.pretendardSemibold(.caption))
                    Spacer()
                case .list:
                    if let isCurrentLocation = isCurrentLocation, let address = address {
                        if isCurrentLocation {
                            Text("나의 위치")
                                .font(.pretendardSemibold(.caption))
                            Spacer()
                        }
                        Text("\(address)")
                            .font(.pretendardSemibold(.caption))
                            .padding(.trailing, 20.responsibleWidth)
                    }
                }
            }
            
            HStack(alignment: .top, spacing: 0) {
                Image("\(currentWeather.weatherCondition.icon)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60.responsibleWidth)
                    .padding(.trailing, 12.responsibleWidth)
                    .padding(.top, 9.responsibleHeight)
                
                // MARK: 온도 및 날씨
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(currentWeather.temperature)° ")
                            .font(.IMHyemin(.title2))
                            .tracking(-(Font.FontSize.title2.rawValue * 0.1))
                        Text("\(currentWeather.weatherCondition.description)")
                            .font(.IMHyemin(.title2))
                            .padding(.leading, -(Font.FontSize.title2.rawValue * 0.3))
                    }
                    .padding(.bottom, 3)
                    
                    // MARK: 최저 최고 온도
                    Text("최고 \(currentWeather.highestTemperature)° | 최저 \(currentWeather.lowestTemperature)°")
                        .font(.pretendardMedium(.footnote))
                }
                .padding(.bottom, 18.responsibleHeight)
                .padding(.top, 12.responsibleHeight)
                
                Spacer()
            }
        }
        .padding(.top, 15.responsibleHeight)
        .padding(.leading, 15.responsibleWidth)
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .strokeBorder(Color.black, lineWidth: 2)
                .contentShape(Rectangle())
        )
        .frame(maxWidth: .infinity, maxHeight: 140)
        .padding(.trailing, 5.responsibleWidth)
    }
}

#Preview {
    WeatherCardLayout(currentWeather: CurrentWeather.placeholder, viewOrigin: .main)
}
