//
//  LocalizedWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI
import WeatherKit

struct LocalizedWeatherView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @StateObject var localizedWeatherViewModel = LocalizedWeatherViewModel()

    var body: some View {
        VStack {
            if toolbarViewModel.isTextFieldActive {
                LocationSearchResultView(localizedWeatherViewModel: localizedWeatherViewModel)
            } else {
                LocalizedWeatherListView(localizedWeatherViewModel: localizedWeatherViewModel)
            }
            if toolbarViewModel.isTextFieldActive && toolbarViewModel.filteredLocations == [] {
                NoResultView()
            }
        }
        .padding(.vertical, 20.responsibleWidth)
        .customNavigationBar(toolbarViewModel: toolbarViewModel, localizedWeatherViewModel: localizedWeatherViewModel)
        .background(Color.seaSky)
    }
}
