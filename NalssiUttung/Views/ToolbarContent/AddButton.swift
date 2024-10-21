//
//  AddButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct AddButton: View {
    @ObservedObject var locationStore = LocationStore()

    var body: some View {
        NavigationLink(destination: LocationListView(locationStore: locationStore)) {
            Image(systemName: "plus")
                .font(.pretendardSemibold(.body))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    AddButton()
}
