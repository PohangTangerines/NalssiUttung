//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import CoreLocation
import SwiftUI
import WeatherKit

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var weatherManager = WeatherManager()
    
    var location: CLLocation?
    var address: String?
    var isCurrentLocation: Bool
    
    let mode: WeatherDisplayMode
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                viewModel.handleDragGesture(gesture)
            }
            .onEnded { gesture in
                viewModel.endDragGesture(gesture)
            }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.seaSky
                    .ignoresSafeArea()
                Group {
                    switch viewModel.displayedContent {
                        
                    case .main:
                        CurrentWeatherView(weatherManager: weatherManager, viewModel: viewModel)
                            .transition(.move(edge: .top))
                            .padding(.horizontal, 20)
                        
                    case .detail:
                        VStack {
                            CurrentWeatherDetailView(weatherManager: weatherManager)
                                .transition(.move(edge: .bottom))
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .gesture(dragGesture)
                .offset(y: viewModel.viewOffsetY)
            }
            .toolbar(content: toolbarContent)
            .task {                
                /// 만약 전달된 위치가 없는 경우 현재 날씨를 불러옵니다.
                /// 전달된 위치가 있는 경우 선택된 위치를 불러옵니다.
                if location == nil {
                    await weatherManager.fetchWeather(with: .all)
                } else {
                    await weatherManager.fetchWeather(with: .all, for: location)
                }
            }
        }
    }
}
