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
    
    @State var address: String?
    
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
                await updateAddress()
                await weatherManager.fetchWeather(with: .all)
            }
        }
    }
    
    @MainActor
    private func updateAddress() async {
        do {
            address = try await LocationManager.shared.getAddress(from: location)
        } catch {
            print("메인 뷰에서 위치로부터 주소를 업데이트하는 데 실패했습니다.")
        }
    }
}
