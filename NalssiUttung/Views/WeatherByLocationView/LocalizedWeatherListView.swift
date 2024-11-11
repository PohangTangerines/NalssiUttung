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
            // TODO: - WeatherListCardView 리팩토링
            WeatherListCardView(weatherManager: weatherManager, locationInfo: locationManager.currentLocationInfo, isCurrentLocation: true)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            
            ForEach(localizedWeatherViewModel.savedLocations) { savedLocation in
                HStack {
                    if toolbarViewModel.isEditMode {
                        Image("deleteButton")
                            .frame(maxWidth: 28, maxHeight: 28)
                            .foregroundStyle(.red)
                            .onTapGesture {
                                if let index = localizedWeatherViewModel.savedLocations.firstIndex(where: { $0.id == savedLocation.id }) {
                                    localizedWeatherViewModel.deleteLocation(at: index)
                                }
                            }
                        Spacer()
                    }
                    WeatherListCardView(locationInfo: savedLocation, isCurrentLocation: false)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .onMove(perform: localizedWeatherViewModel.move)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
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
