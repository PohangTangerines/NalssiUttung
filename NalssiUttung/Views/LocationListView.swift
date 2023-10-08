//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI


struct LocationListView: View {
    @Binding var weatherBoxData: WeatherBoxData?

    let sampledata = RealTimeWeather.sampleCardData

    @State private var searchText = ""
    @State private var isCardExpanded = false // 카드 확장/축소 상태를 추적

    var body: some View {
        // MARK: Weather Widgets
        List {
            ForEach(sampledata, id: \.condition) { forecast in
                LocationCard(weatherBoxData: $weatherBoxData)
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.seaSky)
        }
        .safeAreaInset(edge: .top) {
            EmptyView()
                .frame(maxHeight: 125)
        }
        .listStyle(.plain)
        .background(Color.seaSky)
        .scrollContentBackground(.hidden)
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText)
        }
        .navigationBarHidden(true)
    }
}

//struct LocationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            LocationListView()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
