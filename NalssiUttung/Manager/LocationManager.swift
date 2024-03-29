//
//  LocationManager.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/17.
//

import Foundation
import CoreLocation
import WidgetKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    private let defaults = UserDefaults(suiteName: "group.nalsam")

    @Published var location: CLLocation?
    @Published var address: String = ""

    override private init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
        guard let location = locations.last else { return }
        let locationData = [location.coordinate.latitude, location.coordinate.longitude]
        defaults?.set(locationData, forKey: "currentLocation")
        WidgetCenter.shared.reloadAllTimelines()
    }

    func getLocationAddress() {
        // 위치 업데이트가 발생한 후에 주소 정보를 가져오기 위해 Reverse Geocoding을 사용합니다.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location ?? CLLocation(latitude: 33, longitude: 126)) { (placemarks, error) in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                // 주소 정보를 파싱하여 필요한 부분만 추출합니다.
                if let locality = placemark.locality, let subLocality = placemark.subLocality {
                    if locality != "제주시" {
                        self.address = "제주공항"
                    } else {
                        self.address = "\(locality) \(subLocality)"
                    }
                    print("현재 위치 주소: \(self.address)")
                }
            }
        }
    }
    
    func findCoordinates(address val: String) -> CLLocation? {
        if let location = LocationInfo.Data.first(where: { $0.address == val }) {
            return CLLocation(latitude: location.latitude, longitude: location.longitude)
        }
        return nil
    }
}
