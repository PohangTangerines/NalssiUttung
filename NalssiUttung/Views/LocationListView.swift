//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI


struct LocationListView: View {
    @Binding var weatherBoxData: WeatherBoxData?

    @State var sampledata = RealTimeWeather.sampleCardData

    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적

    var body: some View {
        // MARK: Weather Widgets
        List {
            LocationCard(weatherBoxData: $weatherBoxData, isEditMode: $isEditMode, isCurrentLocation: .constant(true))
                                .frame(maxWidth: .infinity, maxHeight: 140)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.seaSky)
            
            ForEach(sampledata.indices, id: \.self) { index in
                HStack {
                    if isEditMode {
                        Button(action: {
                            // 삭제 버튼을 탭하면 해당 항목을 삭제합니다.
                            sampledata.remove(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }

                    LocationCard(weatherBoxData: $weatherBoxData, isEditMode: $isEditMode, isCurrentLocation: .constant(false))
                                        .frame(maxWidth: .infinity, maxHeight: 140)
                                        .listRowSeparator(.hidden)
                }
                .listRowSeparator(.hidden)
            }
//            .onDelete(perform: deleteItem)
            .onMove(perform: moveItem)
            .listRowBackground(Color.seaSky)
        }
        .safeAreaInset(edge: .top) {
            EmptyView()
                .frame(maxHeight: 125)
        }
        .listStyle(.plain)
        .background(Color.seaSky)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(isEditMode ? EditMode.active : EditMode.inactive))
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText, isEditMode: $isEditMode)
        }
        .onAppear(perform: {
            print(weatherBoxData?.currentTemperature)
        })
    }

    func deleteItem(offsets: IndexSet) {
        sampledata.remove(atOffsets: offsets)
    }

    func moveItem(from source: IndexSet, to destination: Int) {
        sampledata.move(fromOffsets: source, toOffset: destination)
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
