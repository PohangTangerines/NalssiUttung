////
////  WeeklyForecastViewModel.swift
////  NalssiUttung
////
////  Created by 금가경 on 11/8/24.
////
//
import SwiftUI
import Foundation

class WeeklyForecastViewModel: ObservableObject {
    
    func getOffsetDot(nowData: WeeklyForecast.Day, dayData: [WeeklyForecast.Day]) -> (first: CGFloat, second: CGFloat) {
        let chartMaxGap: Double = 90
        // -100 -> dummy
        var minTemp: Int = 100
        var maxTemp: Int = -100
        
        for data in dayData {
            // 최소, 최대 온도 비교 및 업데이트
            minTemp = min(minTemp, data.lowestTemperature, data.highestTemperature)
            // 최대 온도 비교 및 업데이트
            maxTemp = max(maxTemp, data.lowestTemperature, data.highestTemperature)
        }
        
        let unitGap = 65 / Double(maxTemp - minTemp)
        let highTempOffSet = chartMaxGap - CGFloat( unitGap * Double(nowData.highestTemperature - minTemp) )
        let lowTempOffset = chartMaxGap - CGFloat( unitGap * Double(nowData.lowestTemperature - minTemp) )
        
        return (highTempOffSet, lowTempOffset)
    }
    
    // MARK: get Line of Chart (for 1 column)
    func getChartLine(dayData: [WeeklyForecast.Day], index: Int, geometry: GeometryProxy) -> (first: Path, second: Path) {
        let todayData = dayData[index]
        let offsetDotPair = getOffsetDot(nowData: todayData, dayData: dayData)
        let highCoorY = offsetDotPair.first.responsibleHeight
        let lowCoorY = offsetDotPair.second.responsibleHeight
        let geoX = geometry.size.width / 2
        
        var nextHighCoorY: CGFloat = 0
        var nextLowCoorY: CGFloat = 0
        var previousHighCoorY: CGFloat = 0
        var previousLowCoorY: CGFloat = 0
        
        if index > 0 {
            let previousDayData = dayData[index-1]
            previousHighCoorY = getOffsetDot(nowData: previousDayData, dayData: dayData).first.responsibleHeight
            previousLowCoorY = getOffsetDot(nowData: previousDayData, dayData: dayData).second.responsibleHeight
        }
        
        if index < 6 {
            let nextDayData = dayData[index+1]
            nextHighCoorY = getOffsetDot(nowData: nextDayData, dayData: dayData).first.responsibleHeight
            nextLowCoorY = getOffsetDot(nowData: nextDayData, dayData: dayData).second.responsibleHeight
        }
        
        let highPath = Path { path in
            // High Temperature Line
            if index == 0 {
                path.move(to: CGPoint(x: geoX, y: highCoorY))
            } else {
                path.move(to: CGPoint(x: 0, y: (highCoorY + previousHighCoorY)/2))
            }
            
            path.addLine(to: CGPoint(x: geoX, y: highCoorY))
            
            if index != 6 {
                path.addLine(to: CGPoint(x: geoX*2, y: (highCoorY + nextHighCoorY)/2))
            }
        }
        
        let lowPath = Path { path in
            // Low Temperature Line
            if index == 0 {
                path.move(to: CGPoint(x: geoX, y: lowCoorY))
            } else {
                path.move(to: CGPoint(x: 0, y: (lowCoorY + previousLowCoorY)/2))
            }
            
            path.addLine(to: CGPoint(x: geoX, y: lowCoorY))
            
            if index != 6 {
                path.addLine(to: CGPoint(x: geoX*2, y: (lowCoorY + nextLowCoorY)/2))
            }
        }
        
        return (highPath, lowPath)
    }
}

