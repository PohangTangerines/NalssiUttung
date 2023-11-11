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
    
    func weatherComment(weatherData: DailyWeatherData) -> String {
        let sunriseDate = weatherData.weather.dailyForecast.forecast.first!.sun.sunrise!
        let sunsetDate = weatherData.weather.dailyForecast.forecast.first!.sun.sunset!
        
        switch self {
        case .hot :
            return ["날씨가 하영 덥수다양. 선풍기영 에어컨 틀고있읍서.","덥고 습해서 죽어지크라.", "아이스크림 녹아블크라, 조물딱 거리지 말앙 빨랑 먹읍써.", "더워부난 바당가서 놀구지하다"].randomElement()!
        case .clear, .mostlyClear :
            if sunriseDate.timeIntervalSinceNow < 0 && sunsetDate.timeIntervalSinceNow > 0 {
                return ["오늘 날씨 잘도 좋아", "볕이 과랑과랑허니 선크림 바르고 다니랜", "날씨 촘말로 좋쿠다. 기지않?"].randomElement()!
            } else {
                return ["밤하늘 촘말로 아꼽다", "제주도 푸릉 밤 그 벨 아래"].randomElement()!
            }
        case .cloudy :
            return "이추룩 날씨 흐려졈신디 우산 챙겨 가시냐?"
        case .partlyCloudy, .mostlyCloudy :
            return "날씨가 산도록 허니 국이 맨도롱 홀 때 호로록 들여 싸붑서"
        case .haze :
            return ["안개 끼었덴허는데 조심해라","안개 심해지민 와리지말고 들어가랜"].randomElement()!
        case .foggy, .blowingDust, .smoky:
            return "육지 사람들 안개가 이추룩 심한데도 무사 돌아댕기는거?"
        case .windy, .breezy :
            return ["바람 강하니 촐람생이처럼 바당 가지 말앙 들어가 있어라","바람 강하멘 재개재개 들어가라"].randomElement()!
        
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms, .tropicalStorm, .hurricane :
            return "아고게! 벼락털어졈신가?"
        case .rain :
            return ["비가 졸락졸락 내렴쪄 우산 챙기쿠라",
                    "비와서 미끄러워져신디 와리지말아라"].randomElement()!
        case .heavyRain :
            return ["비가 자락자락 내렴쪄 대맹이에 구멍나겠쿠다", "비가 와싹 오는디 괜히 바당같은데 가지말라", "한라산 꼭대기까정 폭삭 젖었지게"].randomElement()!
        case .drizzle, .freezingDrizzle, .sunShowers :
            return "영 비와신디 괜히 비 맞고 고뿔들리지 않게 조심해라"
        case .snow , .hail:
            return "눈 온다 고라신디 경하면 돌하르방 대맹이에 눈 하영 쌓이겠지게"
        case .frigid:
            return "겨울이여부난 입김이 막 나와부신디"
        case .heavySnow, .blizzard, .blowingSnow, .flurries , .sunFlurries:
            return ["눈이 제라 와신디 한라산 대맹이가 새하얘지쿠다","눈이 제라 와신디 돌하르방 대맹이가 새하얘지쿠다"].randomElement()!
        case .freezingRain, .sleet, .wintryMix :
            return ["겨울이여부난 입김이 막 나와부신디","비온덴허니 고뿔 안들리게 맹심허랜"].randomElement()!
            
        default :
            return "기본 멘트"
        }
    }
    
    func weatherCharacter(weatherData: DailyWeatherData) -> String {
        let sunriseDate = weatherData.weather.dailyForecast.forecast.first!.sun.sunrise!
        let sunsetDate = weatherData.weather.dailyForecast.forecast.first!.sun.sunset!

        switch self {
        case .clear, .mostlyClear, .hot :
            if sunriseDate.timeIntervalSinceNow < 0 && sunsetDate.timeIntervalSinceNow > 0 {
                return "clearCharacter"
            } else {
                return "clearNightCharacter"
            }
        case .cloudy :
            return "cloudyCharacter"
        case .partlyCloudy, .mostlyCloudy :
            if sunriseDate.timeIntervalSinceNow < 0 && sunsetDate.timeIntervalSinceNow > 0 {
                return "partlyCloudyCharacter"
            } else {
                return "partlyCloudyNightCharacter"
            }
        case .haze, .foggy, .blowingDust, .smoky :
            return "foggyCharacter"
        case .windy, .breezy :
            return "windyCharacter"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms, .tropicalStorm, .hurricane :
            return "thunderstormCharacter"
        case .rain, .drizzle, .freezingDrizzle, .sunShowers :
            return "rainCharacter"
        case .heavyRain :
            return "heavyRainCharacter"
        case .snow, .heavySnow, .blizzard, .blowingSnow, .flurries , .sunFlurries, .frigid, .hail:
            return "snowCharacter"
        case .freezingRain, .sleet, .wintryMix :
            return "freezingRainCharacter"
        
        default :
            return "clearCharacter"
        }
    }
}
