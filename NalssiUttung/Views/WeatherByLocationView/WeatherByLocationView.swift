//
//  WeatherByLocationView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI
import WeatherKit

struct WeatherByLocationView: View {
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel

    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                LocationSearchResultView(weatherByLocationViewModel: weatherByLocationViewModel)
            } else {
                WeatherByLocationListView(weatherByLocationViewModel: weatherByLocationViewModel)
            }
            if toolbarViewModel.isTextFieldActive && toolbarViewModel.filteredLocations == [] {
                NoResultView()
            }
        }
        .padding(.vertical, 20.responsibleWidth)
        .customNavigationBar(toolbarViewModel: toolbarViewModel)
        .background(Color.seaSky)
    }
}
