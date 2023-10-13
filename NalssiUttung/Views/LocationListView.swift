//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.


import SwiftUI
import WeatherKit

struct LocationListView: View {
    @State var cardWeatherBoxData: WeatherBoxData?
    @Binding var weatherBoxData: WeatherBoxData?
    @Binding var currentLocation: String

    let weatherManager = WeatherService.shared

    @State private var items = UserDefaults.standard.stringArray(forKey: "items") ?? ["test"]

    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false

    //MARK: Modal 관련
    @State private var isModalVisible = false
    @State var modalState: ModalState = .isModalViewAndNotContainedContent

    var filteredItems: [String] {
            if searchText.isEmpty {
                modalState = .isModalViewAndNotContainedContent
                return items
            } else {
                modalState = .isModalViewAndContainedContent
                return items.filter { $0.contains(searchText) }
            }
        }


    var body: some View {
        ZStack{
            // MARK: Weather Widgets
            List {
                if !isTextFieldActive {
                    LocationCard(weatherBoxData: $weatherBoxData, isEditMode: $isEditMode, location: $currentLocation, isCurrentLocation: .constant(true))
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.seaSky)
                }

                if filteredItems != [] {
                    ForEach(filteredItems, id: \.self) { item in
                    HStack {
                        if isEditMode {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(.red)
                                .onTapGesture{
                                    if let index = items.firstIndex(of: item) {
                                        items.remove(at: index)
                                    }
                                }
                            Spacer()
                        }
                        LocationCard(weatherBoxData: $cardWeatherBoxData, isEditMode: $isEditMode, location: .constant(item), isCurrentLocation: .constant(false))
                            .frame(maxWidth: .infinity, maxHeight: 140)
                            .listRowSeparator(.hidden)
                            .task{
                                if let weatherData = await weatherManager.getWeatherInfoForAddress(address: item) {
                                    self.cardWeatherBoxData = weatherData
                                    print(self.cardWeatherBoxData)
                                    print("현재 온도: \(weatherData.currentTemperature)°C")
                                    print("최고 온도: \(weatherData.highestTemperature)°C")
                                    print("최저 온도: \(weatherData.lowestTemperature)°C")
                                    print("날씨 상태: \(weatherData.weatherCondition)")

                                }else {
                                    print("날씨 정보를 가져오지 못했습니다.")
                                }
                            }
                    }
                    .listRowSeparator(.hidden)
                }
                    .onMove(perform: moveItem) // 항목 이동 기능
                    .listRowBackground(Color.seaSky)
                }
            }
            .onTapGesture {
                if isTextFieldActive && filteredItems != [] {
                    isModalVisible.toggle()
                }
                                // 항목을 탭할 때 아무런 동작 없음
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
            .sheet(isPresented: $isModalVisible, content: {
                            // 새로운 뷰 표시
                CardModalView(modalState: $modalState, isModalVisible: $isModalVisible)
            })
            .onAppear {
                // 앱이 시작될 때 UserDefaults에서 항목 불러오기
                UserDefaults.standard.set(["제주시 아라동", "제주시 오라동", "제주시 연동"], forKey: "items")
                items = UserDefaults.standard.stringArray(forKey: "items") ?? ["제주시 아라동", "제주시 오라동", "제주시 연동"]
                print(items)
            }

            if filteredItems == []{
                VStack{
                    Image("donut")
                        .background(Color.seaSky)
                        .safeAreaInset(edge: .top) {
                            EmptyView()
                                .frame(maxHeight: 93)
                        }
                    Text("검색 결과가 없어요")
                        .font(.IMHyemin(.body))
                }
            }
        }
        .background(Color.seaSky)
    }

    // 항목 삭제 함수

        func deleteItem(at offsets: IndexSet) {
            items.remove(atOffsets: offsets)
            saveItems() // 항목 삭제 후 UserDefaults에 저장
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
