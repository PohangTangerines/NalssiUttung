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

    var body: some View {
        ZStack {
            // MARK: Background
            Color.seaSky
                .ignoresSafeArea()

            // MARK: Weather Widgets
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(sampledata, id: \.condition) { forecast in
                        LocationCard(weatherBoxData: $weatherBoxData)
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .padding(.horizontal, 15)
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
