//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI
import WeatherKit

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
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
        // TODO: - Toolbar로 전환 후 변경된 레이아웃 수정 필요
        NavigationView {
            ZStack {
                Color.seaSky
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    switch viewModel.displayedContent {
                    case .main:
                        CurrentWeatherView(weatherManager: viewModel.weatherManager, canTransition: $viewModel.canTransition, isModalVisible: .constant(true), isModal: false)
                            .transition(.move(edge: .top))
                    case .detail:
                        CurrentWeatherDetailView(weatherManager: viewModel.weatherManager)
                            .transition(.move(edge: .bottom))
                            .transition(.move(edge: .bottom))
                    }
                }
                .padding(.horizontal, 15)
                .gesture(dragGesture)
                .offset(y: viewModel.viewOffsetY)
                .toolbar(content: toolbarContent)
                .task {
                    await viewModel.weatherManager.fetchWeather(with: .all)
                }
            }
        }
    }
}
