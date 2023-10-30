//
//  Weather+.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/10.
//

import SwiftUI
import WeatherKit

extension WeatherCondition {
    // weatherCondition -> 이미지 에셋 String.
    func weatherIcon() -> String {
        var icon = ""

        switch self {
        case .blizzard, .heavySnow, .blowingSnow, .wintryMix, .flurries,
                .freezingDrizzle, .snow, .freezingRain, .sleet, .sunFlurries:
            icon = "snow"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms:
            icon = "lightning"
        case .hail:
            icon = "snow"
        case .frigid:
            icon = "dayClear" // 추위 아이콘(추후)
        case .hot:
            icon = "dayClear" // 더위 아이콘(추후)
        case .clear, .mostlyClear:
            icon = "dayClear"
        case .breezy, .windy:
            icon = "windy"
        case .tropicalStorm:
            icon = "rainy" // 폭풍 아이콘
        case .hurricane:
            icon = "windy" // 허리케인 아이콘
        case .heavyRain, .rain, .drizzle, .sunShowers:
            icon = "rainy"
        case .foggy, .haze, .smoky:
            icon = "haze"
        case .blowingDust:
            icon = "haze" // 황사
        case .cloudy, .mostlyCloudy:
            icon = "cloudy"
        case .partlyCloudy:
            icon = "partlyCloudy"
        default:
            icon = "dayClear"
        }
        return icon
    }
    
    func weatherString() -> String {
        var str = ""

        switch self {
        case .blizzard, .heavySnow, .blowingSnow, .wintryMix, .flurries,
                .freezingDrizzle, .snow, .freezingRain, .sleet, .sunFlurries:
            str = "눈"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms:
            str = "뇌우"
        case .hail:
            str = "우박"
        case .frigid:
            str = "혹한" // 추위 아이콘(추후)
        case .hot:
            str = "혹서" // 더위 아이콘(추후)
        case .clear, .mostlyClear:
            str = "맑음"
        case .breezy, .windy:
            str = "바람"
        case .tropicalStorm:
            str = "폭풍" // 폭풍 아이콘
        case .hurricane:
            str = "허리케인" // 허리케인 아이콘
        case .heavyRain, .rain, .drizzle, .sunShowers:
            str = "비"
        case .foggy, .haze:
            str = "안개"
        case .smoky:
            str = "안개(연기)"
        case .blowingDust:
            str = "황사" // 황사
        case .cloudy, .mostlyCloudy:
            str = "흐림"
        case .partlyCloudy:
            str = "구름조금"
        default:
            str = "맑음"
        }
        return str
    }
}
