//
//  WeatherDataFormatter.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/29/24.
//
import Foundation

class WeatherDataFormatter {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private static let measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
    
    static func celsiusTemperature(from temperature: Measurement<UnitTemperature>) -> Int {
        return Int(temperature.converted(to: .celsius).value)
    }
    
    static func timeWithMinutes(from date: Date) -> String {
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: date)

    }
    
    static func timeWithHourOnly(from date: Date) -> String {
        dateFormatter.dateFormat = "a h시"
        return dateFormatter.string(from: date)
    }
    
    static func dayOfWeek(from date: Date) -> String {
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    static func monthAndDay(from date: Date) -> String {
        dateFormatter.dateFormat = "M.dd"
        return dateFormatter.string(from: date)
    }
    
    static func monthDayAndDayOfWeek() -> String {
        let today = Date()
        dateFormatter.dateFormat = "M월 d일 E요일"
        return dateFormatter.string(from: today)
    }
    
    static func windSpeed(from windSpeed: Measurement<UnitSpeed>) -> String {
        measurementFormatter.unitOptions = .providedUnit
        return measurementFormatter.string(from: windSpeed)
    }
    
    static func visibility(from visibility: Measurement<UnitLength>) -> String {
        measurementFormatter.unitOptions = .naturalScale
        measurementFormatter.numberFormatter.maximumFractionDigits = 0

        return measurementFormatter.string(from: visibility)
    }

    static func precipitationAmount(from precipitationAmount: Measurement<UnitLength>) -> String {
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        
        return measurementFormatter.string(from: precipitationAmount)
    }

    static func precipitationDescription(from precipitation: String) -> String {
        switch precipitation {
        case "none" : return "없음"
        case "hail" : return "우박"
        case "mixed" : return "혼합강우"
        case "rain" : return "비"
        case "sleet" : return "진눈깨비"
        case "snow" : return "눈"
        default: return "결과 없음"
        }
    }
    
    static func precipitationProbability(from chance: Double) -> String {
        return "\(Int(chance * 100))%"
    }
    
    static func koreanWindDirection(from compassDirection: String) -> String {
        switch compassDirection {
        case "north": return "북풍"
        case "northNortheast": return "북북동풍"
        case "northeast": return "북동풍"
        case "eastNortheast": return "동북동풍"
        case "east": return "동풍"
        case "eastSoutheast": return "동남풍"
        case "southeast": return "남동풍"
        case "southSoutheast": return "남남동풍"
        case "south": return "남풍"
        case "southSouthwest": return "남남서풍"
        case "southwest": return "남서풍"
        case "westSouthwest": return "서남서풍"
        case "west": return "서풍"
        case "westNorthwest": return "서북서풍"
        case "northwest": return "북서풍"
        case "northNorthwest": return "북북서풍"
        default: return "알 수 없음"
        }
    }
}
