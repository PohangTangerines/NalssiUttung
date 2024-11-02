//
//  ToolbarViewModel.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//
import SwiftUI

class ToolbarViewModel: ObservableObject {
    @Published var isEditMode: Bool = false
    
    // MARK: - SearchBar 관련 property
    @Published var searchText: String = ""
    @Published var isTextFieldActive: Bool = false
}
