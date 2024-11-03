//
//  ToolbarViewModel.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//
import SwiftUI

class ToolbarViewModel: ObservableObject {
    // MARK: - EditMode 관련 property
    @Published var isEditMode: Bool = false
    
    // MARK: - SearchBar 관련 property
    @Published var isTextFieldActive: Bool = false
    
    // TODO: - 추후 ToolbarViewModel 말고 다른 뷰모델로 이동시키기
    @Published var searchText: String = "" {
        didSet {
            filterLocations()
        }
    }
    @Published var filteredLocations: [String] = []
    
    private var allLocations: [String] = LocationInfo.Data.map { $0.address }
    
    private func filterLocations() {
        if searchText.isEmpty {
            filteredLocations = allLocations
        } else {
            filteredLocations = allLocations.filter { $0.contains(searchText) }
        }
    }

}
