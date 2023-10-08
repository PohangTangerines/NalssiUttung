//
//  Color+Palette.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/11.
//

import SwiftUI

extension Color {
    // MARK: Hex Init
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

extension Color {
    // MARK: MainColor
    static var seaSky: Self {
        .init(hex: "#A0DCFF")
    }
    static var halaGreen: Self {
        .init(hex: "#A0FFC8")
    }
    static var sunshine: Self {
        .init(hex: "#FFFFA0")
    }
    static var gyul: Self {
        .init(hex: "#FFC8A0")
    }
    static var jejuCoral: Self {
        .init(hex: "#FFA0A0")
    }
    // MARK: GrayScale
    static var basalt: Self {
        .init(hex: "#888888")
    }
    static var darkChacoal: Self {
        .init(hex: "#444444")
    }
    static var buttonBlue: Self {
        .init(hex: "#9CA9D2")
    }
    
    // MARK: Others..
    static var accentBlue: Self {
        .init(hex: "4C65B9").opacity(0.2)
    }
}

struct ColorPalette_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.seaSky
            Color.halaGreen
            Color.sunshine
            Color.gyul
            Color.jejuCoral
            Color.basalt
            Color.darkChacoal
        }
    }
}
