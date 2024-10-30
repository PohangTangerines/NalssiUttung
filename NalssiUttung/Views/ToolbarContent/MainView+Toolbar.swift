//
//  MainView+Toolbar.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

extension MainView {
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            CurrentLocation(location: $viewModel.locationManager.currentAddress)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            AddButton()
        }
    }
}
