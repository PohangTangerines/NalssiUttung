//
//  LocalizedWeatherListView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI
import CoreLocation

struct LocalizedWeatherListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    @State var isCurrentLocation: Bool = true
    
    /// 항목들을 이동시킬 수 있어야 하기 때문에 LazyVStack과 ScrollView의 조합 대신 List를 사용했습니다.
    /// .onMove로 항목을 이동시킬 수 있습니다. 
    var body: some View {
        List {
            Group {
                WeatherListCardView()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        isCurrentLocation = true
                        toolbarViewModel.isModalPresented = true
                    }
                
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
                        WeatherListCardView(locationInfo: savedLocation)
                            .onTapGesture {
                                let location = CLLocation(latitude: savedLocation.coordinate.latitude,
                                                          longitude: savedLocation.coordinate.longitude)
                                localizedWeatherViewModel.selectedLocation = location

                                locationManager.selectedLocation = location
                                
                                isCurrentLocation = false
                                toolbarViewModel.isModalPresented = true
                            }
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
            MainView(location: isCurrentLocation ?
                     locationManager.currentLocation :
                     locationManager.selectedLocation, mode: localizedWeatherViewModel.mode)
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
