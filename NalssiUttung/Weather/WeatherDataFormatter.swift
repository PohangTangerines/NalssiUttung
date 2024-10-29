//
//  WeatherDataFormatter.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/29/24.
//
import Foundation

// TODO: - WeatherDataFormatter class로 변경 후 Refactor
func unitTempToInt(temp: Measurement<UnitTemperature>) -> Int {
    return Int(temp.converted(to: .celsius).value)
}

func dateToDetailTimeString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a h:mm"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func dateToTimeString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a h시"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func dateToDayString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M.dd"
    dateFormatter.locale = Locale(identifier:"ko_KR")
    
    return dateFormatter.string(from: date)
}

func precipitationToKoreanString(_ precipitation: String) -> String {
    switch precipitation {
    case "none" :
        return "없음"
    case "hail" :
        return "우박"
    case "mixed" :
        return "혼합강우"
    case "rain" :
        return "비"
    case "sleet" :
        return "진눈깨비"
    case "snow" :
        return "눈"
    default:
        return "결과 없음"
    }
}
func precipitationChanceDoubleToPercentage(precipitationChance: Double) -> String {
    return "\(Int(precipitationChance * 100))%"
}

func convertToKoreanWindDirection(_ compassDirection: String) -> String {
    switch compassDirection {
    case "north" :
        return "북풍"
    case "northNortheast" :
        return "북북동풍"
    case "northeast" :
        return "북동풍"
    case "eastNortheast" :
        return "동북동풍"
    case "east" :
        return "동풍"
    case "eastSoutheast" :
        return "동남풍"
    case "southeast" :
        return "남동풍"
    case "southSoutheast" :
        return "남남동풍"
    case "south" :
        return "남풍"
    case "southSouthwest" :
        return "남남서풍"
    case "southwest" :
        return "남서풍"
    case "westSouthwest" :
        return "서남서풍"
    case "west" :
        return "서풍"
    case "westNorthwest" :
        return "서북서풍"
    case "northwest" :
        return "북서풍"
    case "northNorthwest" :
        return "북북서"
    default:
        return "알 수 없음"
    }
}

func unitWindSpeedToString(windSpeed: Measurement<UnitSpeed>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .providedUnit
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 1
    
    return measurementFormatter.string(from: windSpeed)
}

func visibilityUnitLengthToString(visibility: Measurement<UnitLength>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .naturalScale
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 0

    return measurementFormatter.string(from: visibility)
}

func precipitationUnitLengthToString(precipitationAmount: Measurement<UnitLength>) -> String {
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .providedUnit
    measurementFormatter.locale = Locale(identifier:"ko_KR")
    measurementFormatter.numberFormatter.maximumFractionDigits = 1
    
    return measurementFormatter.string(from: precipitationAmount)
}
