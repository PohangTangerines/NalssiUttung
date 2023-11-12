//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.

import SwiftUI
import WeatherKit

struct LocationListView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    let weatherManager = WeatherService.shared
    let locations = LocationInfo.Data.map { $0.address }
    
    @ObservedObject var locationStore: LocationStore
    @State var selectedLocations: [String]?
    @State var currnetLocation: String?
    @State var searchLocation: [String]?
    @State var modalState: ModalState?
    
    // MARK: SearchBar 관련
    @FocusState private var isFocused: Bool
    @State private var searchText = ""
    @State private var isEditMode = false // 삭제 모드 활성화 여부를 추적
    @State var isTextFieldActive = false
    
    // MARK: Modal 관련
    @State private var isSearchModalVisible = false
    @State private var isSelectedModalVisible = false
    @State private var isCurrentWeatherModalVisible = false
    
    var filteredLocations: [String] {
        return locations.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // MARK: Weather Widgets
            if isTextFieldActive {
                searchBarList
            } else {
                selectedList
            }
            if isTextFieldActive && filteredLocations == [] {
                emptyView
            }
        }
        .overlay {
            // MARK: Navigation Bar
            NavigationBar(searchText: $searchText, isEditMode: $isEditMode, isTextFieldActive: $isTextFieldActive, isFocused: _isFocused)
        }
    }
    private var searchBarList : some View {
        List {
            ForEach(filteredLocations.prefix(10), id: \.self) { filteredLocation in
                HStack() {
                    if let range = filteredLocation.range(of: searchText, options: .caseInsensitive) {
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
                .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !isSelectedModalVisible && !isCurrentWeatherModalVisible{
                        locationStore.selectedfilteredLocationForModal = filteredLocation
                        isSearchModalVisible = true
                        if let searchLocation = searchLocation, (searchLocation.contains(locationStore.selectedfilteredLocationForModal) || locationManager.address == locationStore.selectedfilteredLocationForModal) {
                            modalState = .isModalViewAndContainedContent
                        } else {
                            modalState = .isModalViewAndNotContainedContent
                        }
                        print("searchBarList onTapGesture: \(filteredLocation)")
                        print("locationStore.selectedfilteredLocationForModal: \(locationStore.selectedfilteredLocationForModal)")
                    }
                }
                .sheet(isPresented: $isSearchModalVisible, content: {
                    // 새로운 뷰 표시
                    CardModalView(modalState: modalState ?? ModalState.isModalViewAndNotContainedContent, isModalVisible: $isSearchModalVisible, location: locationStore.selectedfilteredLocationForModal, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode, isCurrentLocation: .constant(false))
                        .onDisappear(){
                            isFocused = false
                            isSearchModalVisible = false
                        }
                })
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
        .onAppear {
            let userList = locationStore.loadLocations()
            selectedLocations = userList
        }
//        .task {
//            do {
//                let userList = try await locationStore.loadLocations()
//                searchLocation = userList
//                print("Success load: \(userList)")
//            } catch{
//                searchLocation = []
//                print("task error")
//            }
//        }
    }
    private var selectedList: some View {
        List {
            currentWeatherView
            ForEach(selectedLocations ?? [], id: \.self) { selectedLocation in
                HStack {
                    if isEditMode {
                        Image("deleteButton")
                            .frame(maxWidth: 28, maxHeight: 28)
                            .foregroundColor(.red)
                            .onTapGesture {
                                if let index = selectedLocations!.firstIndex(of: selectedLocation) {
                                    selectedLocations?.remove(at: index)
                                    locationStore.saveLocations(come: selectedLocations!)
                                }
                            }
                        Spacer()
                    }
                    LocationCard(location: selectedLocation, isCurrentLocation: .constant(false))
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            if !isTextFieldActive {
                                locationStore.selectedLocationForModal = selectedLocation
                                isSelectedModalVisible = true
                            }
                        }
                        .sheet(isPresented: $isSelectedModalVisible, content: {
                            CardModalView(modalState: ModalState.isModalViewAndContainedContent, isModalVisible: $isSelectedModalVisible, location: locationStore.selectedLocationForModal, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode, isCurrentLocation: .constant(false))
                                .onDisappear(){
                                    isSelectedModalVisible = false
                                }
                        })
                }
                .listRowSeparator(.hidden)
            }
            .onMove(perform: move) // 항목 이동 기능
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
        .onAppear {
            let userList = locationStore.loadLocations()
            selectedLocations = userList
        }
//        .task {
//            do {
//                let userList = try await locationStore.loadLocations()
//                selectedLocations = userList
//                print("Success load: \(userList)")
//            } catch {
//                selectedLocations = []
//                print("task error")
//            }
//        }
    }
    private var emptyView: some View {
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
        }
        .background(Color.seaSky)
    }
    private var currentWeatherView: some View{
        HStack{
            LocationCard(location: locationManager.address, isCurrentLocation: .constant(true))
                .frame(maxWidth: .infinity, maxHeight: 140)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    if !isTextFieldActive {
                        isCurrentWeatherModalVisible = true
                    }
                }
                .sheet(isPresented: $isCurrentWeatherModalVisible, content: {
                    CardModalView(modalState: ModalState.isModalViewAndContainedContent, isModalVisible: $isCurrentWeatherModalVisible, location: locationManager.address, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode, isCurrentLocation: .constant(true))
                        .onDisappear(){
                            isCurrentWeatherModalVisible = false
                        }
                })
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.seaSky)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        selectedLocations!.move(fromOffsets: source, toOffset: destination)
        locationStore.saveLocations(come: selectedLocations!)
    }
}
