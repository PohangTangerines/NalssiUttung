//
//  WeatherError.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/29/24.
//

import Foundation

enum CustomWeatherError: Error {
    /// 위치정보 불러오기 관련 에러
    case noLocationInfo
    case locationUnavilable
    case noAddress
    
    /// 날씨 fetch 관련 에러
    case weatherRequestFailed
    case noFetchedWeatherData
    
    /// dailyForecast 불러오기 관련 에러
    case noDailyForecast
    case sunEventUnavailable

    var localizedDescription: String {
        
        switch self {
        /// 위치정보 불러오기 관련 에러
        case .noLocationInfo:
            return "저장된 위치 정보가 없습니다. "
        case .locationUnavilable:
            return "위치 정보를 불러올 수 없습니다."
        case .noAddress:
        
        /// 날씨 fetch 관련 에러
            return "주소를 불러올 수 없습니다."
        case .weatherRequestFailed:
            return "날씨를 가져오는 데 실패했습니다."
        case .noFetchedWeatherData:
            return "현재 날씨를 불러올 수 있는 날씨 데이터가 없습니다."
            
        /// dailyForecast 불러오기 관련 에러
        case .sunEventUnavailable:
            return "일출/일몰 시간을 불러올 수 없습니다."
        case .noDailyForecast:
            return "일간 날씨 예보가 없습니다."
        }
    }
}
