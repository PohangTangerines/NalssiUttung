//
//  MiniSamchun.swift
//  MiniSamchun
//
//  Created by 이재원 on 2/27/24.
//

import WidgetKit
import SwiftUI
import WeatherKit
import CoreLocation

struct Provider: AppIntentTimelineProvider {
    let weatherManager = WeatherService.shared
    let defaults = UserDefaults(suiteName: "group.nalsam")
    
    func placeholder(in context: Context) -> SimpleEntry {
        // TODO: weather nil 처리
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), weather: nil, location: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        // TODO: weather nil 처리
        SimpleEntry(date: Date(), configuration: configuration, weather: nil, location: nil)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let weather = await getWeather()

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, weather: weather, location: readLocation())
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func getWeather() async -> Weather? {
        // TODO: 에러 처리 및 nil 처리
        guard let location = readLocation(),
              let weather = await weatherManager.getWeather(location: location) else {
            return nil
        }
        return weather
    }
    
    private func readLocation() -> CLLocation? {
        guard let locationData = defaults?.array(forKey: "currentLocation") as? [Double],
              locationData.count == 2 else { return nil }
        return CLLocation(latitude: locationData[0], longitude: locationData[1])
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let weather: Weather?
    let location: CLLocation?
}

struct MiniSamchunEntryView : View {
    let weatherManager = WeatherService.shared
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let weather = entry.weather, let location = entry.location {
                let weatherBoxData = weatherManager.getWeatherBoxData(location: location, weather: weather)
                let dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
                
                HStack {
                    Text("\(weatherBoxData.weatherCondition.weatherComment(weatherData: dailyWeatherData))")
                        .font(.IMHyemin(.caption))
                        .IMHyeminLineHeight(.title, lineHeight: 10)
                    Spacer()
                }
//                Text("성공")
            } else {
                Text("불러오기 실패")
//                Text("Time:")
//                Text(entry.date, style: .time)
//    
//                Text("Favorite Emoji:")
//                Text(entry.configuration.favoriteEmoji)
            }
        }
    }
}

struct MiniSamchun: Widget {
    let kind: String = "MiniSamchun"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()
        ) { entry in
            MiniSamchunEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    MiniSamchun()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
