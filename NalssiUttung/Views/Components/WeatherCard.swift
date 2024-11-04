//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct WeatherCard: View {
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager: WeatherManager
    
    let address: String
    let isCurrentLocation: Bool
    
    var body: some View {
        Group {
            switch weatherManager.currentWeather {
            case .some(let currentWeather):
                SimpleCurrentWeatherInfo(weather: currentWeather, isCurrentLocation: isCurrentLocation, address: address)
            case .none:
                SimpleCurrentWeatherInfo(weather: CurrentWeather.placeholder, isCurrentLocation: isCurrentLocation, address: address)
                    .redacted(reason: .placeholder)
            }

        }
        .task {
            // TODO: - UserDefault에 저장하는 값 CLLocation(longitude, latitude)로 바꾸고 findCoordiates 제거
            if isCurrentLocation {
                await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .current)
            } else {
                if let location = locationManager.findCoordinates(address: address) {
                    await weatherManager.fetchWeather(for: location, with: .current)
                }
            }
        }
    }
}

struct SimpleCurrentWeatherInfo: View {
    let weather: CurrentWeather
    let isCurrentLocation: Bool
    let address: String
    
    var body: some View {
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
                        
            HStack(alignment: .top, spacing: 0) {
                Image("\(weather.weatherCondition.icon)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60.responsibleWidth)
                    .padding(.trailing, 12.responsibleWidth)
                    .padding(.top, 9.responsibleHeight)
                
                // MARK: 온도 및 날씨
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(weather.temperature)° ")
                            .font(.IMHyemin(.title2))
                            .tracking(-(Font.FontSize.title2.rawValue * 0.1))
                        Text("\(weather.weatherCondition.description)")
                            .font(.IMHyemin(.title2))
                            .padding(.leading, -(Font.FontSize.title2.rawValue * 0.3))
                    }
                    .padding(.bottom, 3)
                    
                    // MARK: 최저 최고 온도
                    Text("최고 \(weather.highestTemperature)° | 최저 \(weather.lowestTemperature)°")
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
    }
}

#Preview {
    WeatherCard(weatherManager: WeatherManager(), address: "제주시 애월읍", isCurrentLocation: true)
}
