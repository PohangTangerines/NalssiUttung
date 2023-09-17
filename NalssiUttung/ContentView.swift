//
//  ContentView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/05.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var weatherManager = WeatherManager.shared
    
    @State private var weatherBoxData: WeatherBoxData?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            if let data = weatherBoxData {
                Text("현재 온도 : \(unitTempToDouble(temp: data.currentTemperature))")
                Text("위도 : \(data.location.coordinate.latitude)")
                Text("경도 : \(data.location.coordinate.longitude)")
                Text("날씨 : \(data.weatherCondition.description)")
                Text("최저온도 : \(unitTempToDouble(temp: data.lowTemperature))")
                Text("최고온도 : \(unitTempToDouble(temp: data.highTemperature))")
            } else {
                Text("날씨 정보를 가져올 수 없습니다.")
            }
        }.padding()
            .task {
                if let location = locationManager.location {
                    self.weatherBoxData = await weatherManager.getWeatherBoxData(location: location)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
