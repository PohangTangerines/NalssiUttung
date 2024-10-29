//
//  Weather+.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/10.
//

import SwiftUI
import WeatherKit

extension WeatherCondition {
    var icon: String {
        switch self {
        case .blizzard, .heavySnow, .blowingSnow, .wintryMix, .flurries,
                .freezingDrizzle, .snow, .freezingRain, .sleet, .sunFlurries:
            return "snow"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms:
            return "lightning"
        case .hail:
            return "snow"
        case .frigid:
            return "dayClear" // 추위 아이콘(추후)
        case .hot:
            return "dayClear" // 더위 아이콘(추후)
        case .clear, .mostlyClear:
            return "dayClear"
        case .breezy, .windy:
            return "windy"
        case .tropicalStorm:
            return "rainy" // 폭풍 아이콘
        case .hurricane:
            return "windy" // 허리케인 아이콘
        case .heavyRain, .rain, .drizzle, .sunShowers:
            return "rainy"
        case .foggy, .haze, .smoky:
            return "haze"
        case .blowingDust:
            return "haze" // 황사
        case .cloudy, .mostlyCloudy:
            return "cloudy"
        case .partlyCloudy:
            return "partlyCloudy"
        default:
            return "dayClear"
            
        }
    }
        
    var description: String {
        switch self {
        case .blizzard, .heavySnow, .blowingSnow, .wintryMix, .flurries,
             .freezingDrizzle, .snow, .freezingRain, .sleet, .sunFlurries:
            return "눈"
        case .strongStorms, .scatteredThunderstorms, .isolatedThunderstorms, .thunderstorms:
            return "뇌우"
        case .hail:
            return "우박"
        case .frigid:
            return "혹한" // 추위 아이콘(추후)
        case .hot:
            return "혹서" // 더위 아이콘(추후)
        case .clear, .mostlyClear:
            return "맑음"
        case .breezy, .windy:
            return "바람"
        case .tropicalStorm:
            return "폭풍" // 폭풍 아이콘
        case .hurricane:
            return "허리케인" // 허리케인 아이콘
        case .heavyRain, .rain, .drizzle, .sunShowers:
            return "비"
        case .foggy, .haze:
            return "안개"
        case .smoky:
            return "안개(연기)"
        case .blowingDust:
            return "황사" // 황사
        case .cloudy, .mostlyCloudy:
            return "흐림"
        case .partlyCloudy:
            return "구름조금"
        default:
            return "맑음"
        }
    }
    
    private func isDayTime(sunrise: Date, sunset: Date) -> Bool {
        return sunrise.timeIntervalSinceNow < 0 && sunset.timeIntervalSinceNow > 0
    }
    
    func character(sunrise: Date, sunset: Date) -> String {
        let isDayTime = isDayTime(sunrise: sunrise, sunset: sunset)
        
        let characterMap: [WeatherCondition: String] = [
            .clear: isDayTime ? "clearCharacter" : "clearNightCharacter",
            .mostlyClear: isDayTime ? "clearCharacter" : "clearNightCharacter",
            .hot: isDayTime ? "clearCharacter" : "clearNightCharacter",
            .cloudy: "cloudyCharacter",
            .partlyCloudy: isDayTime ? "partlyCloudyCharacter" : "partlyCloudyNightCharacter",
            .mostlyCloudy: isDayTime ? "partlyCloudyCharacter" : "partlyCloudyNightCharacter",
            .haze: "foggyCharacter",
            .foggy: "foggyCharacter",
            .blowingDust: "foggyCharacter",
            .smoky: "foggyCharacter",
            .windy: "windyCharacter",
            .breezy: "windyCharacter",
            .strongStorms: "thunderstormCharacter",
            .scatteredThunderstorms: "thunderstormCharacter",
            .isolatedThunderstorms: "thunderstormCharacter",
            .thunderstorms: "thunderstormCharacter",
            .tropicalStorm: "thunderstormCharacter",
            .hurricane: "thunderstormCharacter",
            .rain: "rainCharacter",
            .drizzle: "rainCharacter",
            .freezingDrizzle: "rainCharacter",
            .sunShowers: "rainCharacter",
            .heavyRain: "heavyRainCharacter",
            .snow: "snowCharacter",
            .heavySnow: "snowCharacter",
            .blizzard: "snowCharacter",
            .blowingSnow: "snowCharacter",
            .flurries: "snowCharacter",
            .sunFlurries: "snowCharacter",
            .frigid: "snowCharacter",
            .hail: "snowCharacter",
            .freezingRain: "freezingRainCharacter",
            .sleet: "freezingRainCharacter",
            .wintryMix: "freezingRainCharacter"
        ]
        
        return characterMap[self] ?? "clearCharacter"
    }
    
    func comment(sunrise: Date, sunset: Date) -> String {
        let isDayTime = isDayTime(sunrise: sunrise, sunset: sunset)
        
        let comments: [WeatherCondition: [String]] = [
            .hot: ["날씨가 하영 덥수다양. 선풍기영 에어컨 틀고있읍서.", "덥고 습해서 죽어지크라.", "아이스크림 녹아블크라, 조물딱 거리지 말앙 빨랑 먹읍써.", "더워부난 바당가서 놀구지하다"],
            .clear: isDayTime ? ["오늘 날씨 잘도 좋아", "볕이 과랑과랑허니 선크림 바르고 다니랜", "날씨 촘말로 좋쿠다. 기지않?"] : ["밤하늘 촘말로 아꼽다", "제주도 푸릉 밤 그 벨 아래"],
            .mostlyClear: isDayTime ? ["오늘 날씨 잘도 좋아", "볕이 과랑과랑허니 선크림 바르고 다니랜", "날씨 촘말로 좋쿠다. 기지않?"] : ["밤하늘 촘말로 아꼽다", "제주도 푸릉 밤 그 벨 아래"],
            .cloudy: ["이추룩 날씨 흐려졈신디 우산 챙겨 가시냐?"],
            .partlyCloudy: isDayTime ? ["하늘이 왁왁해졈시니 비 오려는지도 모르겠쿠다"] : ["구름이 잔뜩 꼈쪄, 조심해서 돌아댕기라"],
            .mostlyCloudy: isDayTime ? ["하늘이 왁왁해졈시니 비 오려는지도 모르겠쿠다"] : ["구름이 잔뜩 꼈쪄, 조심해서 돌아댕기라"],
            .haze: ["안개 끼었덴허는데 조심해라", "안개 심해지민 와리지말고 들어가랜"],
            .foggy: ["안개가 이추룩 심한데도 무사 돌아댕기는거?", "안개 심해져신디 천천히 다녀라"],
            .blowingDust: ["먼지가 하영 날린다 조심허랜", "먼지 많아보이난 마스크 쓰고 다니라"],
            .smoky: ["연기 심해져신디 밖에 와리지 말라", "연기 냄시 나쿠라, 창문 닫아놔라"],
            .windy: ["바람 강하니 촐람생이처럼 바당 가지 말앙 들어가 있어라", "바람 강하멘 재개재개 들어가라"],
            .breezy: ["바람이 선선해서 걷기 좋다", "산책하기 좋은 바람 분다"],
            .strongStorms: ["아고게! 벼락털어졈신가?", "폭풍 오고있으니 밖에 나가지 마라"],
            .scatteredThunderstorms: ["벼락 칠 것 같으니 조심해라", "폭풍 올 때까지 실내에 있어라"],
            .isolatedThunderstorms: ["벼락 칠 것 같으니 조심해라", "번개가 어딘가서 칠지도 몰라, 실내에 있어라"],
            .thunderstorms: ["아고게! 벼락털어졈신가?", "폭풍 올 때까지 실내에 있어라"],
            .tropicalStorm: ["폭풍 올 때까지 실내에 있어라", "태풍 오고있으니 대비해라"],
            .hurricane: ["태풍 온다, 절대 밖에 나가지 마라", "큰 태풍 오니까 바깥 나가지 말라"],
            .rain: ["비가 졸락졸락 내렴쪄 우산 챙기쿠라", "비와서 미끄러워져신디 와리지말아라"],
            .drizzle: ["비가 졸락졸락 내렴쪄 우산 챙기쿠라", "조금씩 비 오쿠라, 우산 챙겨라"],
            .freezingDrizzle: ["비온덴허니 고뿔 안들리게 맹심허랜", "차갑게 비 내리니까 따뜻하게 입어라"],
            .sunShowers: ["비가 내리는데 해가 떴네", "이거 어디 무지개 뜨는 날씨 아이가?"],
            .heavyRain: ["비가 자락자락 내렴쪄 대맹이에 구멍나겠쿠다", "비가 와싹 오는디 괜히 바당같은데 가지말라", "한라산 꼭대기까정 폭삭 젖었지게"],
            .snow: ["눈이 하얗게 쌓이고 있쿠다", "눈 온다 고라신디 한라산 대맹이도 새하얗겠지게"],
            .heavySnow: ["눈이 제라 와신디 한라산 대맹이가 새하얘지쿠다", "눈이 제라 와신디 돌하르방 대맹이가 새하얘지쿠다"],
            .blizzard: ["눈보라 불어신디 따뜻하게 입어라", "눈보라 쳐서 밖에 나가지 마라"],
            .blowingSnow: ["눈이 바람에 날려부난 조심해라", "눈 날리난 안에서 쉬어라"],
            .flurries: ["눈이 살짝 내리니까 즐겨라", "가볍게 눈이 오쿠라, 기분 좋구나"],
            .sunFlurries: ["햇살 속 눈발, 참 보기 좋다", "햇살에 눈 내리쿠라, 경치 좋네"],
            .frigid: ["겨울이여부난 입김이 막 나와부신디", "찬바람 세게 부니까 따뜻하게 입어라"],
            .freezingRain: ["비온덴허니 고뿔 안들리게 맹심허랜", "비와서 땅 미끄럽다, 조심해라"],
            .sleet: ["차가운 비 내리니 따뜻하게 입어라", "땅이 미끄러워져신디 천천히 다니라"],
            .wintryMix: ["비랑 눈이 섞여서 내린다, 우산 챙겨라", "눈비가 섞여 내린다, 천천히 다녀라"]
        ]
        
        if let conditionComments = comments[self], let randomComment = conditionComments.randomElement() {
            return randomComment
        }
        
        return "오늘 날씨 잘도 좋아"
    }
}
