//
//  WeatherError.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/29/24.
//

import Foundation

enum CustomWeatherError: Error {
    case sunEventUnavailable
    
    var localizedDescription: String {
        
        switch self {
        case .sunEventUnavailable:
        return "일출/일몰 시간을 불러올 수 없습니다."
            
        }
    }
}
