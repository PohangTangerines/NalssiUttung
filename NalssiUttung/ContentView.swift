//
//  ContentView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            if let location = locationManager.getCurrentLocation() {
                Text("위도: \(location.coordinate.latitude)")
                Text("경도: \(location.coordinate.longitude)")
            } else {
                Text("위치 정보를 가져올 수 없습니다.")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
