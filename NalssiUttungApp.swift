//
//  NalssiUttungApp.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/05.
//

import SwiftUI
import WeatherKit

@main
struct NalssiUttungApp: App {
    @StateObject var toolbarViewModel = ToolbarViewModel()
    @State private var splashOpacity: Double = 1.0
    
    // TODO: - 애니메이션 때문에 malloc 에러 발생으로 추정. 가능하면 애니메이션 프레임워크 제거하기.
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView(isCurrentLocation: LocationManager.shared.isDeviceLocation, mode: .regular)
                    .environmentObject(toolbarViewModel)
                SplashScreenView()
                    .opacity(splashOpacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                            withAnimation {
                                splashOpacity = 0.0
                            }
                        }
                    }
            }
        }
    }
}
