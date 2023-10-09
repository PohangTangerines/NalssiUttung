//
//  RealTimeWeather.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import Foundation

struct RealTimeWeather {
    var location: String
    var condition: String
    var temperature: Int
    var lowTemperature: Int
    var highTemperature: Int
    var weatherMessage: String
}

extension RealTimeWeather {
    static let sampleData: [RealTimeWeather] = [
        RealTimeWeather(location: "제주시 아라동", condition: "맑음", temperature: 24, lowTemperature: 24, highTemperature: 33, weatherMessage: "일교차 크난\n고뿔 들리지 않게\n조심합서!")
    ]
    static let sampleCardData: [RealTimeWeather] = [
        RealTimeWeather(location: "제주시 아라동", condition: "맑음", temperature: 24, lowTemperature: 24, highTemperature: 33, weatherMessage: "일교차 크난\n고뿔 들리지 않게\n조심합서!"),
        RealTimeWeather(location: "제주시 아라동", condition: "맑음", temperature: 24, lowTemperature: 24, highTemperature: 33, weatherMessage: "일교차 크난\n고뿔 들리지 않게\n조심합서!"),
        RealTimeWeather(location: "제주시 아라동", condition: "맑음", temperature: 24, lowTemperature: 24, highTemperature: 33, weatherMessage: "일교차 크난\n고뿔 들리지 않게\n조심합서!")
    ]
}
