//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct WeatherOverview: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    let address: String
    let isCurrentLocation: Bool
        
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if isCurrentLocation {
                        Text("나의 위치")
                            .font(.pretendardSemibold(.caption))
                        Spacer()
                    }
                    Text("\(address)")
                        .font(.pretendardSemibold(.caption))
                        .padding(.trailing, 20.responsibleWidth)
                }
                
                // TODO: - 기본값 설정해서 뷰 찌그러지는 것 해결
                if let currentWeather = weatherManager.currentWeather {
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
                                Text("\(currentWeather.currentTemperature)° ")
                                    .font(.IMHyemin(.title2))
                                    .tracking(-(Font.FontSize.title2.rawValue * 0.1))
                                Text("\(currentWeather.weatherCondition.getWeatherString())")
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
            }
            .padding(.top, 15.responsibleHeight)
            .padding(.leading, 15.responsibleWidth)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .strokeBorder(Color.black, lineWidth: 1.5)
                    .contentShape(Rectangle())
            )
        }
        .task {
            // TODO: - UserDefault에 저장하는 값 CLLocation(longitude, latitude)로 바꾸고 findCoordiates 제거
            if isCurrentLocation {
                await weatherManager.fetchWeather(with: .current)
            } else {
                if let location = locationManager.findCoordinates(address: address) {
                    await weatherManager.fetchWeather(for: location, with: .current)
                }
            }
        }
    }
}

#Preview {
    WeatherOverview(address: "제주시 애월읍", isCurrentLocation: true)
}
