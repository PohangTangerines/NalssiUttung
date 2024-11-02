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
            AddButton(action: updateSelectedAddresses, mode: mode, isModalPresented: $isModalPresented, isTextFieldActive: $isTextFieldActive)
        }
    }
    
    // TODO: - 추가 시 중복 방지 해결하기
    func updateSelectedAddresses() {
        
        let locationList = locationViewModel.loadLocations() + [locationManager.selectedAddress]
        locationViewModel.saveLocations(come: locationList)
    }
}
