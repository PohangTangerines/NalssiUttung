//
//  LocationSearchResultView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/4/24.
//

import CoreLocation
import SwiftUI

struct LocationSearchResultView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    
    // TODO: - 뷰 분리 완료, 추후 뷰모델로 분리 필요.
    // TODO: - 텍스트 bold 대신 색상 바꾸기
    var body : some View {
        List {
            ForEach(toolbarViewModel.filteredLocations.prefix(10), id: \.self) { filteredLocation in
                SavedLocationView(localizedWeatherViewModel: localizedWeatherViewModel, filteredLocation: filteredLocation)

            }
            .listRowBackground(Color.seaSky)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $toolbarViewModel.isModalPresented) {
            MainView(location: localizedWeatherViewModel.selectedLocation,
                     isCurrentLocation: localizedWeatherViewModel.isCurrentLocation, mode: localizedWeatherViewModel.mode)
        }
    }
}

struct SavedLocationView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    
    let filteredLocation: String
    
    var body: some View {
        HStack {
            if let range = filteredLocation.range(of: toolbarViewModel.searchText, options: .caseInsensitive) {
                let beforeText = filteredLocation[..<range.lowerBound]
                let searchText = filteredLocation[range]
                let afterText = filteredLocation[range.upperBound...]
                
                Text(beforeText)
                +
                Text(searchText)
                    .bold()
                +
                Text(afterText)
            } else {
                Text(filteredLocation)
            }
        }
        .onTapGesture {
            localizedWeatherViewModel.updateSelectedLocation(for: filteredLocation)
            
            guard let location = LocationManager.shared.findLocationInfo(for: filteredLocation) else {
                print(CustomWeatherError.noLocationInfo.localizedDescription)
                return
            }
            
            localizedWeatherViewModel.selectedLocation = CLLocation(latitude: location.coordinate.latitude,
                                                                 longitude: location.coordinate.longitude)
            localizedWeatherViewModel.determineWeatherDisplayMode(for: filteredLocation)
            localizedWeatherViewModel.isCurrentLocation = false
            toolbarViewModel.isModalPresented = true
        }
        .listRowSeparator(.hidden)

    }
}

#Preview {
    LocationSearchResultView(localizedWeatherViewModel: LocalizedWeatherViewModel())
}
