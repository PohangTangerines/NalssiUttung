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
    @StateObject var weatherLocationManager = WeatherLocationManager()
    
    var location: CLLocation?
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
                        CurrentWeatherView(weatherLocationManager: weatherLocationManager, viewModel: viewModel)
                            .transition(.move(edge: .top))
                            .padding(.horizontal, 20)
                        
                    case .detail:
                        VStack {
                            CurrentWeatherDetailView(weatherLocationManager: weatherLocationManager)
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
                weatherLocationManager.selectedLocation = location
                await weatherLocationManager.fetchWeather(with: .all)
            }
        }
    }
}
