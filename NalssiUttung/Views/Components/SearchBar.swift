//
//  SerchBar.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct SearchBar: View {
    @StateObject var weatherByLocationViewModel = WeatherByLocationViewModel()

    var body: some View {
        HStack {
            HStack(spacing: 2.responsibleWidth) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.darkChacoal)

                TextField("title", text: $weatherByLocationViewModel.searchText, prompt: Text("지역 검색하기").foregroundColor(Color.darkChacoal))
                    .font(.pretendardMedium(.callout))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation {
                            weatherByLocationViewModel.isTextFieldActive = true
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }

            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 6.responsibleWidth)
            .padding(.vertical, 28.responsibleHeight)
            .frame(maxHeight: 45.responsibleHeight, alignment: .leading)
            .background(Color.seaSky, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.darkChacoal, lineWidth: 2))

            if weatherByLocationViewModel.isTextFieldActive {
                Button(action: {
                    weatherByLocationViewModel.isTextFieldActive = false
                    weatherByLocationViewModel.searchText = ""
                }, label: {
                    Text("취소")
                        .font(.pretendardSemibold(.callout))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
                })

            }
        }
    }

}

#Preview {
    SearchBar()
}
