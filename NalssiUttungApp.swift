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
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView(mode: .regular)
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
