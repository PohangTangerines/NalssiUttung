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
    private let jejuAirportLocation = CLLocation(latitude: 33.5115, longitude: 126.4911)
    
    @Published var location: CLLocation {
        didSet {
            updateAddress()
        }
    }
    
    @Published var address: String = ""
    
    override private init() {
        self.location = jejuAirportLocation
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /// 사용자 위치 권한 허가를 받지 못했을 때 기본 위치를 제주공항으로 설정합니다.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            location = jejuAirportLocation
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last ?? jejuAirportLocation
        guard let location = locations.last else { return }
        let locationData = [location.coordinate.latitude, location.coordinate.longitude]
        defaults?.set(locationData, forKey: "currentLocation")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// 업데이트한 location을 한글 주소로 변경합니다.
    /// 현재 제주(제주시, 서귀포시)가 아닌 경우 address는 제주공항으로 설정됩니다.
    func updateAddress() {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("주소 변환 오류: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first,
               let locality = placemark.locality,
               let subLocality = placemark.subLocality {
                
                switch (locality, subLocality) {
                case ("제주시", "용담이동"):
                    self.address = "제주공항"
                case ("제주시", _), ("서귀포시", _):
                    self.address = "\(locality) \(subLocality)"
                default:
                    self.address = "제주공항"
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
