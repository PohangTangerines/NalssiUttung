//
//  LocalizedWeatherListView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI

struct LocalizedWeatherListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var weatherManager = WeatherManager()
    
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    var body: some View {
        List {
            Group {
                // TODO: - WeatherListCardView 리팩토링
                WeatherListCardView(weatherManager: weatherManager, locationInfo: locationManager.currentLocationInfo, isCurrentLocation: true)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                ForEach(localizedWeatherViewModel.savedLocations) { savedLocation in
                    HStack {
                        if toolbarViewModel.isEditMode {
                            Button {
                                localizedWeatherViewModel.deleteLocationIfexist(for: savedLocation)
                            } label: {
                                Image("deleteButton")
                                    .frame(maxWidth: 28, maxHeight: 28)
                                    .foregroundStyle(.red)
                            }
                        }
                        WeatherListCardView(locationInfo: savedLocation, isCurrentLocation: false)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .onMove(perform: localizedWeatherViewModel.move)
            }
            .listRowSeparator(.hidden)
            .scrollIndicators(.never)
        }
        .listStyle(.plain)
        .sheet(isPresented: $toolbarViewModel.isModalPresented) {
            MainView(mode: .modalInList, viewOrigin: .list)
        }
        .environment(\.editMode, .constant(toolbarViewModel.isEditMode ? EditMode.active : EditMode.inactive))
        .task {
            // TODO: - savedLocation 변경 값이 뷰에 반영되지 않아서 뷰를 불러올때마다 받아오도록 함. 추후 제거할 수 있으면 제거
            localizedWeatherViewModel.loadLocations()
        }
    }
}

#Preview {
    LocalizedWeatherView()
        .environmentObject(ToolbarViewModel())
}
