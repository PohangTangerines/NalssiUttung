//
//  LocalizedWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI
import WeatherKit

struct LocalizedWeatherView: View {
    @StateObject var localizedWeatherViewModel = LocalizedWeatherViewModel()
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel

    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                LocationSearchResultView(localizedWeatherViewModel: localizedWeatherViewModel)
            } else {
                WeatherByLocationListView(weatherByLocationViewModel: localizedWeatherViewModel)
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
