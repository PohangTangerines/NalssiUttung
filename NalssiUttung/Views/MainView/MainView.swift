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
    // TODO: - locationManager와 weatherManager 어떻게 전달할지 고민해 보기.
    @StateObject var viewModel = MainViewModel()
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    let mode: WeatherDisplayMode
    let viewOrigin: ViewOrigin
    
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
                switch viewOrigin {
                case .list: await weatherManager.fetchWeather(for: locationManager.selectedLocation, with: .all)
                case .main:
                    locationManager.currentLocation = await locationManager.requestCurrentLocation()
                    await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .all)
                }
            }
        }
    }
}
