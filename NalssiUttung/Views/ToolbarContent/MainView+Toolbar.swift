//
//  MainView+Toolbar.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

// TODO: - toolbar 대신 뷰로 변경해서 isModalPresented 떼내기
extension MainView {
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if mode == .modal || mode == .modalInList {
                CancelButton(isModalPresented: $isModalPresented, mode: mode)
            }
        }
        
        ToolbarItem(placement: .principal) {
            if locationManager.selectedLocation != nil {
                LocationHeader(location: locationManager.selectedAddress, isCurrentLocation: false)
                    .onDisappear {
                        locationManager.selectedLocation = nil
                    }
            } else {
                LocationHeader(location: locationManager.currentAddress, isCurrentLocation: true)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            AddButton(action: weatherByLocationViewModel.updateSavedLocations, mode: mode, isModalPresented: $isModalPresented, isTextFieldActive: $isTextFieldActive)
        }
    }
}
