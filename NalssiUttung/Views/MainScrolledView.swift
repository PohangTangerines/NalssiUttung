//
//  MainScrolledView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/04.
//

import SwiftUI

struct MainScrolledView: View {
    @Binding var weatherBoxData: WeatherBoxData?

    var body: some View {
        VStack(spacing: 0) {            
            LocationCardScrolled(weatherBoxData: $weatherBoxData)
        }.padding(.horizontal, 15).background(Color.seaSky)
    }
}
