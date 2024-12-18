//
//  MainView+Toolbar.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

extension MainView {
    // TODO: - toolbar MainView에서 분리해서 ToolbarViewModel로 분리할지 고민해 보기.
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if mode == .modal || mode == .modalInList {
                CancelButton(mode: mode)
            }
        }
        
        ToolbarItem(placement: .principal) {
            if location == nil {
                LocationHeader(address: LocationManager.shared.currentAddress,
                               isCurrentLocation: true)
            } else {
                LocationHeader(address: address,
                               isCurrentLocation: false)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            if let address = address {
                AddButton(locationInfo: LocationManager.shared.findLocation(for: address), mode: mode)
            } else {
                AddButton(mode: mode)
            }
        }
    }
}
