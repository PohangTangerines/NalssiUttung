//
//  LocationManager.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/09/17.
//

import Foundation
import CoreLocation

/// 현재 위치 정보 관련한 변수와 메서드가 있는 클래스입니다.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    static let shared = LocationManager()
    private let jejuAirport = CLLocation(latitude: LocationInfo.Data.first!.coordinate.latitude, longitude: LocationInfo.Data.first!.coordinate.longitude)
    
    var currentLocation: CLLocation? {
        didSet {
            Task {
                @MainActor in
                if let currentLocation = currentLocation {
                    guard let newAddress = try await getAddress(from: currentLocation) else { return }
                    currentAddress = newAddress
                } else {
                    currentAddress = ""
                }
            }
            
        }
    }
    
    @Published var currentAddress: String = ""
    private(set) var isDeviceLocation = false
    
    private let updateState = UpdateState()
    private var permissionContinuation: CheckedContinuation<Bool, Never>?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func checkAndRequestLocationPermission() async -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            return await requestPermission()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 권한이 승인되었습니다.")
            return true
            
        default:
            print("위치 권한이 거부되었습니다.")
            return false
        }
    }
    
    private func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            locationManager.requestWhenInUseAuthorization()
            self.permissionContinuation = continuation
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한이 변경되었습니다.")
        
        if let continuation = permissionContinuation {
            let status = manager.authorizationStatus
            let permissionGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
            continuation.resume(returning: permissionGranted)
            permissionContinuation = nil
        }
    }
    
    func setDefaultLocation() {
        self.currentLocation = jejuAirport
        self.currentAddress = "제주공항"
        self.isDeviceLocation = false
    }

    func isLocationJeju(for location: CLLocation) -> Bool {
        let jejuCenter = CLLocation(latitude: 33.4996, longitude: 126.5312)
        
        // 제주도는 대략 50km 정도의 반경을 가지므로, 이 범위 내에 있으면 제주도로 간주
        let distance = location.distance(from: jejuCenter)
        
        // 제주도 범위 기준 (50km 이내)
        let jejuRadius: CLLocationDistance = 50000
        
        return distance <= jejuRadius
    }
    
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
        
        let permissionGranted = await checkAndRequestLocationPermission()
        
        guard permissionGranted else {
            print("위치 권한이 거부되어 기본 위치로 업데이트 완료했습니다. ")
            setDefaultLocation()
            return
        }
        
        do {
            let updates = CLLocationUpdate.liveUpdates()
            for try await update in updates {

                if let currentLocation = update.location {
                    
                    let isJeju = isLocationJeju(for: currentLocation)
                    
                    if isJeju {
                        self.currentLocation = currentLocation
                        self.isDeviceLocation = true
                        print("제주도 내부에서 현재 위치로 업데이트를 완료했습니다.")

                    } else {
                        setDefaultLocation()
                        print("제주도 외부에서 기본 위치로 위치 업데이트 완료했습니다.")

                    }
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
    
    func findLocationInfo(from address: String) -> LocationInfo? {
        return LocationInfo.Data.first(where: { $0.address == address })
    }
    
    func findLocation(from address: String) -> CLLocation? {
        guard let coordinate = LocationInfo.Data.first(where: { $0.address == address })?.coordinate else {
            return nil
        }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
