//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.
//

import SwiftUI

struct LocationForecast {
    let location: String
    let temperature: Int
    let low: Int
    let high: Int
    // 다른 필요한 속성들 추가
}

struct LocationListView: View {
    @State private var searchText = ""

    let searchResults: [LocationForecast] = [
            LocationForecast(location: "제주시 아라동", temperature: 32, low: 20, high: 30),
            LocationForecast(location: "제주시 가라동", temperature: 28, low: 25, high: 35),
            LocationForecast(location: "제주시 나라동", temperature: 28, low: 25, high: 35),
            LocationForecast(location: "제주시 다라동", temperature: 25, low: 22, high: 30),
            LocationForecast(location: "제주시 라라동", temperature: 22, low: 10, high: 30),
            LocationForecast(location: "제주시 마라동", temperature: 20, low: 28, high: 25),
            LocationForecast(location: "제주시 바라동", temperature: 25, low: 22, high: 20)
        ]

    var body: some View {
        ZStack {
            // MARK: Background
            Color.seaSky
                .ignoresSafeArea()

            // MARK: Weather Widgets
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(searchResults, id: \.location) { forecast in
                        LocationCard(location: forecast.location, temperature: forecast.temperature, high: forecast.high, low: forecast.low)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                EmptyView()
                    .frame(maxHeight: 125)
            }
        }
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText)
        }
        .navigationBarHidden(true)
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationListView()
                .preferredColorScheme(.dark)
        }
    }
}
