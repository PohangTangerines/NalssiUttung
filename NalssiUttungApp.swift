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
    @State private var splashOpacity: Double = 1.0
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
