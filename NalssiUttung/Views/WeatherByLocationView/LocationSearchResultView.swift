//
//  LocationSearchResultView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/4/24.
//

import SwiftUI

struct LocationSearchResultView: View {
    @ObservedObject var toolbarViewModel: ToolbarViewModel
    @ObservedObject var weatherByLocationViewModel: WeatherByLocationViewModel
    
    // TODO: - 뷰 분리 완료, 추후 뷰모델로 분리 필요.
    // TODO: - 맨 처음 모달을 누를 때 모달창이 자동으로 내려가는 현상 개선 필요
    // TODO: - 텍스트 bold 대신 색상 바꾸기
    var body : some View {
        List {
            ForEach(toolbarViewModel.filteredLocations.prefix(10), id: \.self) { filteredLocation in
                HStack {
                    if let range = filteredLocation.range(of: toolbarViewModel.searchText, options: .caseInsensitive) {
                        let beforeText = filteredLocation[..<range.lowerBound]
                        let searchText = filteredLocation[range]
                        let afterText = filteredLocation[range.upperBound...]
                        
                        Text(beforeText)
                        +
                        Text(searchText)
                            .bold()
                        +
                        Text(afterText)
                    } else {
                        Text(filteredLocation)
                    }
                }
                .onTapGesture {
                    weatherByLocationViewModel.updateSelectedLocation(for: filteredLocation)
                }
                .sheet(isPresented: $weatherByLocationViewModel.isModalPresented) {
                    let mode: WeatherDisplayMode = (weatherByLocationViewModel.savedLocations.contains(filteredLocation) == true) ? .modalInList : .modal
                    MainView(mode: mode, isModalPresented: $weatherByLocationViewModel.isModalPresented, isTextFieldActive: $toolbarViewModel.isTextFieldActive)
                        .onDisappear {
                            weatherByLocationViewModel.isModalPresented = false
                        }
                    
                }
                .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.seaSky)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }}

#Preview {
    LocationSearchResultView(toolbarViewModel: ToolbarViewModel(), weatherByLocationViewModel: WeatherByLocationViewModel())
}
