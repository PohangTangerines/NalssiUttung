//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI


struct LocationListView: View {
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var location: String

    @State var sampledata = RealTimeWeather.sampleCardData

    @State private var testList = ["test1", "test2", "test3"]
    @State private var items = UserDefaults.standard.stringArray(forKey: "items") ?? ["test"]

    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false
    @State private var showNewView = false // 새로운 뷰 표시 여부를 관리하는 상태 변수

    var filteredItems: [String] {
            if searchText.isEmpty {
                return items
            } else {
                return items.filter { $0.contains(searchText) }
            }
        }


    var body: some View {
        ZStack{

            // MARK: Weather Widgets
            List {
                if !isTextFieldActive {
                    LocationCard(weatherBoxData: $weatherBoxData, isEditMode: $isEditMode, location: $location, isCurrentLocation: .constant(true))
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.seaSky)
                }


                ForEach(filteredItems, id: \.self) { item in
                    HStack {
                        if isEditMode {
                            Button(action: {
                                deleteItem(item) // 항목 삭제 버튼 클릭 시 삭제
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                        }
                        Text(item)
                        LocationCard(weatherBoxData: $weatherBoxData, isEditMode: $isEditMode,  location: $location, isCurrentLocation: .constant(false))
                                                                .frame(maxWidth: .infinity, maxHeight: 140)
                                                                .listRowSeparator(.hidden)
                    }
                    .listRowSeparator(.hidden)
                }
                .onMove(perform: moveItem) // 항목 이동 기능
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
                NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive)
            }
            .sheet(isPresented: $showNewView, content: {
                            // 새로운 뷰 표시
                            Text("새로운 뷰가 표시됩니다.")
                        })
            .onAppear {
                // 앱이 시작될 때 UserDefaults에서 항목 불러오기
                UserDefaults.standard.set(["test1", "test2", "test3"], forKey: "items")
                items = UserDefaults.standard.stringArray(forKey: "items") ?? testList
                print(items)
            }
        }
    }

    // 항목 삭제 함수
        func deleteItem(_ item: String) {
            if let index = items.firstIndex(of: item) {
                items.remove(at: index)
                saveItems() // 항목 삭제 후 UserDefaults에 저장
            }
        }

        // 항목 이동 함수
        func moveItem(from source: IndexSet, to destination: Int) {
            items.move(fromOffsets: source, toOffset: destination)
            saveItems() // 항목 이동 후 UserDefaults에 저장
        }

        // 항목을 UserDefaults에 저장하는 함수
        func saveItems() {
            UserDefaults.standard.set(items, forKey: "items")
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
