//
//  SplashScreenView.swift
//  NalssiUttung
//
//  Created by been on 11/12/23.
//

import SwiftUI
import Gifu

struct SplashScreenView: View {
    @State private var gifName: String = "splash"
    @State private var showMainView = false
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            Color.seaSky.edgesIgnoringSafeArea(.all)
            VStack {
                AnimatedSplashGifView(gifName: $gifName)
                    .frame(width: UIScreen.main.bounds.width)
                    .opacity(opacity)
            }
        }
    }
}
