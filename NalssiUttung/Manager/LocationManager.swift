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
    
    @Published var location: CLLocation?
    @Published var address: String = ""

    override private init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
//        print("load location")

        // 위치 업데이트가 발생한 후에 주소 정보를 가져오기 위해 Reverse Geocoding을 사용합니다.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                // 주소 정보를 파싱하여 필요한 부분만 추출합니다.
                if let locality = placemark.locality, let subLocality = placemark.subLocality {
                    self.address = "\(locality) \(subLocality)"
                    print("현재 위치 주소: \(self.address)")
                }
            }
        }
    }
}
