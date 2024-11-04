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
    @Binding var isModalPresented: Bool
    @Binding var isTextFieldActive: Bool
    
    init(mode: WeatherDisplayMode, isModalPresented: Binding<Bool> = .constant(false), isTextFieldActive: Binding<Bool> = .constant(false)) {
        self.mode = mode
        _isModalPresented = isModalPresented
        _isTextFieldActive = isTextFieldActive
    }
    
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
        NavigationView {
            VStack {
                switch viewModel.displayedContent {
                case .main:
                    CurrentWeatherView(weatherManager: weatherManager, viewModel: viewModel)
                        .transition(.move(edge: .top))
                case .detail:
                    CurrentWeatherDetailView(weatherManager: weatherManager)
                        .transition(.move(edge: .bottom))
                }
            }
            .padding(.horizontal, 20)
            .background(Color.seaSky)
            .gesture(dragGesture)
            .offset(y: viewModel.viewOffsetY)
            .toolbar(content: toolbarContent)
            .task {
                if let selectedLocation = locationManager.selectedLocation {
                    await weatherManager.fetchWeather(for: selectedLocation, with: .all)
                } else {
                    await weatherManager.fetchWeather(for: locationManager.currentLocation, with: .all)
                }
            }
        }
    }
}
