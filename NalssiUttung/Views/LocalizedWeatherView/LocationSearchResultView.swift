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
            ForEach(toolbarViewModel.filteredAddresses.prefix(10), id: \.self) { filteredAddress in
                SavedLocationView(localizedWeatherViewModel: localizedWeatherViewModel, filteredAddress: filteredAddress)

            }
            .listRowBackground(Color.seaSky)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $toolbarViewModel.isModalPresented) {
            MainView(location: localizedWeatherViewModel.selectedLocation,
                     address: localizedWeatherViewModel.selectedAddress,
                     isCurrentLocation: localizedWeatherViewModel.isCurrentLocation,
                     mode: localizedWeatherViewModel.mode)
        }
    }
}

struct SavedLocationView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    
    let filteredAddress: String
    
    var body: some View {
        HStack {
            if let range = filteredAddress.range(of: toolbarViewModel.searchText, options: .caseInsensitive) {
                let beforeText = filteredAddress[..<range.lowerBound]
                let searchText = filteredAddress[range]
                let afterText = filteredAddress[range.upperBound...]
                
                Text(beforeText)
                +
                Text(searchText)
                    .bold()
                +
                Text(afterText)
            } else {
                Text(filteredAddress)
            }
        }
        .onTapGesture {
            localizedWeatherViewModel.updateSelectedLocation(from: filteredAddress)
            localizedWeatherViewModel.determineWeatherDisplayMode(for: filteredAddress)
            toolbarViewModel.isModalPresented = true
        }
        .listRowSeparator(.hidden)

    }
}

#Preview {
    LocationSearchResultView(localizedWeatherViewModel: LocalizedWeatherViewModel())
}
