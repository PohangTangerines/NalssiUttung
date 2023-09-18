//
//  DetailedWeatherData.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import Foundation

 struct DetailedWeatherData {
     var precipitation: Int
     var wind: String
     var windSpeed: Double
     var visibilityState: String
     var visibility: Int
     
 }

 extension DetailedWeatherData {
     static let sampleData: [DetailedWeatherData] = [
        DetailedWeatherData(precipitation: 0, wind: "북동풍", windSpeed: 3.2, visibilityState: "매우 좋음", visibility: 22)
     ]
 }
