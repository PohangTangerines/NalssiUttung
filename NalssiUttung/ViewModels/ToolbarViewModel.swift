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
    
    // MARK: - Modal 관련 property
    @Published var isModalPresented: Bool = false
    
    // TODO: - 추후 ToolbarViewModel 말고 다른 뷰모델로 이동시키기
    @Published var searchText: String = "" {
        didSet {
            filterAddresses()
        }
    }
    
    @Published var filteredAddresses: [String] = []

    private var allAddresses: [String] = LocationInfo.Data.map { $0.address }
    
    private func filterAddresses() {
        if searchText.isEmpty {
            filteredAddresses = allAddresses
        } else {
            filteredAddresses = allAddresses.filter { $0.contains(searchText) }
        }
    }

}
