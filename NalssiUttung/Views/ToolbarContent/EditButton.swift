//
//  EditButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct EditButton: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var localizedWeatherViewModel: LocalizedWeatherViewModel
    
    var body: some View {
        if !toolbarViewModel.isTextFieldActive, !localizedWeatherViewModel.savedLocations.isEmpty {
            Button {
                withAnimation {
                    saveUpdates()
                }
            } label: {
                Text(toolbarViewModel.isEditMode ? "완료" : "편집")
                    .font(.pretendardMedium(.callout))
                    .foregroundStyle(Color.black)
            }
        }
    }
    
    func saveUpdates() {
        if toolbarViewModel.isEditMode {
            localizedWeatherViewModel.saveOrderInCoreData()
            localizedWeatherViewModel.deleteLocationsInCoreData()
        }
        toolbarViewModel.isEditMode.toggle()
    }
}

#Preview {
    EditButton(localizedWeatherViewModel: LocalizedWeatherViewModel())
}
