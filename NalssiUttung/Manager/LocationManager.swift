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
    private var locationManager = CLLocationManager()
    static let shared = LocationManager()
    private let jejuAirport = CLLocation(latitude: 33.5115, longitude: 126.4911)
        
    var currentLocation: CLLocation? {
        didSet {
            if currentLocation != jejuAirport {
                updateAddress(for: .current, location: currentLocation)
            }
        }
    }
    
    var selectedLocation: CLLocation? {
        didSet {
            updateAddress(for: .selected, location: selectedLocation)
        }
    }
    
    @Published var currentAddress: String = "" {
        didSet {
            self.currentLocationInfo = findLocation(for: currentAddress)
            print("currentAddress: \(currentAddress)")
        }
    }
    
    @Published var selectedAddress: String = "" {
        didSet {
            print("selectedAddress: \(selectedAddress)")
        }
    }
    
    // TODO: - LocationInfo 삭제하기
    @Published var currentLocationInfo: LocationInfo?
    
    private let updateState = UpdateState()

    /// 현재 위치를 요청합니다. liveUpdates를 사용합니다.
    /// liveUpdates가 기기의 실시간 정보를 받아오는 기능이라 시뮬레이터에서 제대로 작동하지 못하는 경우도 종종 발생합니다.
    /// 실기기에서는 정상 작동합니다.
    func updateCurrentLocation() async {
        guard await updateState.startUpdating() else {
            print("현재 위치 업데이트가 이미 진행 중입니다.")
            return
        }

        defer {
            Task {
                await updateState.stopUpdating()
            }
        }
        
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            print("위치 권한이 허용되지 않았습니다. 상태: \(status)")
            self.currentLocation = jejuAirport
            updateAddress(for: .current, location: self.currentLocation)
            return
        }
        
        do {
            let updates = CLLocationUpdate.liveUpdates()
            for try await update in updates {
                if let currentLocation = update.location {
                    print("현재 위치는: \(currentLocation)")
                    
                    self.currentLocation = currentLocation
                    return
                } else {
                    print("위치 업데이트가 유효하지 않습니다. 다시 시도 중...")
                }
            }
        } catch {
            print("위치 업데이트 중 에러 발생: \(error.localizedDescription)")
        }
    }
    
    /// 업데이트한 location을 한글 주소로 변경합니다.
    /// 현재 제주(제주시, 서귀포시)가 아닌 경우 address는 제주공항으로 설정됩니다.
    func updateAddress(for type: AddressType, location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("주소 변환 오류: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first,
               let locality = placemark.locality,
               let subLocality = placemark.subLocality {
                
                let address: String
                var location = self?.currentLocation
                
                switch (locality, subLocality) {
                case ("제주시", "용담이동"):
                    address = "제주공항"
                case ("제주시", _), ("서귀포시", _):
                    address = "\(locality) \(subLocality)"
                default:
                    location = self?.jejuAirport
                    address = "제주공항"
                }
                
                switch type {
                case .current:
                    self?.currentLocation = location
                    self?.currentAddress = address

                case .selected:
                    self?.selectedAddress = address
                }
            }
        }
    }
    
    /// 업데이트한 location을 한글 주소로 변경합니다.
    /// 현재 제주(제주시, 서귀포시)가 아닌 경우 address는 제주공항으로 설정됩니다.
    func getAddress(from location: CLLocation?) async throws -> String? {
        guard let location = location else {
            print(CustomWeatherError.locationUnavilable)
            return nil
        }
        
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        if let placemark = placemarks.first,
           let locality = placemark.locality,
           let subLocality = placemark.subLocality {
            
            switch (locality, subLocality) {
            case ("제주시", "용담이동"):
                return "제주공항"
            case ("제주시", _), ("서귀포시", _):
                return  "\(locality) \(subLocality)"
            default:
                return "제주공항"
            }
        }
        return nil
    }
    
    func findLocation(for address: String) -> LocationInfo? {
        return LocationInfo.Data.first(where: { $0.address == address })
    }
    
    func updateSelectedLocation(for address: String) {
        if let updatedLocation = findLocation(for: address) {
            self.selectedLocation = CLLocation(latitude: updatedLocation.coordinate.latitude,
                                               longitude: updatedLocation.coordinate.longitude)
        }
    }

}
