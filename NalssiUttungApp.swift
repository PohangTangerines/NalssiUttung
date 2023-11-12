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
    @State var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView(showSplash: $showSplash)
                if showSplash{
                    SplashScreenView() // 스플래시 뷰
                        .opacity(splashOpacity)
                        .onAppear {
                            // 스플래시 화면이 표시된 후 일정 시간이 지나면 메인 화면으로 이동
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                                withAnimation {
                                    splashOpacity = 0.0 // 페이드 아웃 효과를 위해 opacity를 0.0으로 변경
                                }
                            }
                        }
                }
            }
        }
    }
}
