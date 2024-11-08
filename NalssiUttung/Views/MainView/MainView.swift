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
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()
    
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
            .toolbar(content: toolbarContent)
            .task {
                locationManager.currentLocation = await locationManager.requestCurrentLocation()
                
                if let selectedLocation = locationManager.selectedLocation {
                    await weatherManager.fetchWeather(for: selectedLocation, with: .all)
                } else {
                    await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .all)
                }
            }
        }
    }
}
