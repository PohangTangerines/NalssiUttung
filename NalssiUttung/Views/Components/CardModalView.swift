//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI
import WeatherKit

struct CardModalView: View {
    // MARK: Weather Data 관련
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager: WeatherManager

    // MARK: Modal 관련
    @State var modalState: ModalState
    @Binding var isModalVisible: Bool
    @State var address: String
    @FocusState var isFocused: Bool
    @Binding var isTextFieldActive: Bool
    @Binding var isEditMode: Bool
    
    // MARK: User 위치 정보 저장 관련
    @Binding var isCurrentLocation: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.seaSky
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    MainHeader(weatherManager: weatherManager, address: $address, modalState: $modalState, isModalVisible: $isModalVisible, isFocused: _isFocused, isTextFieldActive: $isTextFieldActive, isEditMode: $isEditMode, isCurrentLocation: $isCurrentLocation)
                    RealTimeWeatherView(weatherManager: weatherManager, canTransition: .constant(false), isModalVisible: .constant(false), isModal: true)
                        .transition(.move(edge: .top))
                }
                .padding(.horizontal, 15)
                .task {
                    if isCurrentLocation {
                        await weatherManager.fetchWeather(with: .all)
                    } else {
                        if let location = locationManager.findCoordinates(address: address) {
                            await weatherManager.fetchWeather(for: location, with: .current)
                        }
                    }
                }
            }
        }
    }
}

private struct MainHeader: View {
    @ObservedObject var weatherManager: WeatherManager
    
    @Binding var address: String
    @Binding var modalState: ModalState
    @Binding var isModalVisible: Bool
    @FocusState var isFocused: Bool
    @Binding var isTextFieldActive: Bool
    @Binding var isEditMode: Bool
    @State var storeList: [String]?
    
    // MARK: User가 선택한 위치 List 관련 값
    @ObservedObject var locationStore = LocationStore()
    let locations = LocationInfo.Data.map { $0.name }
    
    @Binding var isCurrentLocation: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Text("\(address)")
                    .font(.pretendardSemibold(.callout))
                if isCurrentLocation {
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            HStack {
                if modalState != .notModalView {
                    Button {
                        isModalVisible = false
                    } label: {
                        Text("취소")
                            .font(.pretendardSemibold(.body))
                            .foregroundColor(.black)
                    }
                }
                Spacer()
                switch modalState {
                case .notModalView:
                    NavigationLink(destination: LocationListView(weatherManager: weatherManager, locationStore: locationStore)) {
                        Image(systemName: "plus")
                            .font(.pretendardSemibold(.body))
                            .foregroundColor(.black)
                    }
                case .isModalViewAndContainedContent:
                    EmptyView()
                case .isModalViewAndNotContainedContent:
                    Button {
                        locationStore.saveLocations(come: storeList ?? [])
                        isFocused = false
                        isTextFieldActive = false
                        isEditMode = false
                        isModalVisible = false
                    } label: {
                        Text("추가")
                            .font(.pretendardSemibold(.body))
                            .foregroundColor(.black)
                    }
                    .task {
                        var list = locationStore.loadLocations()
                        list.append(address)
                        storeList = list
                        print(storeList)
                        print("success storeList in CardModalView")
                    }
                }
            }
        }
        .padding(.top, 34.responsibleHeight)
        .padding(.bottom, 24.responsibleHeight)
    }
}
