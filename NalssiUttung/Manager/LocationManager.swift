//
//  LocationManager.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/17.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    
    override private init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        print("load location")
    }
    
    
    /// WeatherKit의 `weatherService.weather(for: CLLocation, ~)` 의 첫 번째 parameter인 CLLocation을 위한,
    /// 현재 위치의 위도, 경도를 추출하여 CLLocation 객체를 return합니다.
    /// CoreLocation의 LocationManager가 정상적으로 작동하지 않았다면, `nil`값을 return합니다.
    ///
    /// - Returns: 현재 위치의 위, 경도를 담은 CLLocation 객체
    func getCurrentLocation() -> CLLocation? {
        if let current = self.location {
            let coor = current.coordinate
            return CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        } else {
            return nil
        }
    }
}
