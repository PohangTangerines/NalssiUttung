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
    @Environment(\.widgetFamily) var family: WidgetFamily
    let weatherManager = WeatherService.shared
    var entry: Provider.Entry
    
    @State private var gifName: String = "clearCharacter"
    
    var body: some View {
        if let weather = entry.weather, let location = entry.location {
            let weatherBoxData = weatherManager.getWeatherBoxData(location: location, weather: weather)
            let dailyWeatherData = weatherManager.getDailyWeatherData(weather: weather)
            let imageName = weatherBoxData.weatherCondition.weatherCharacter(weatherData: dailyWeatherData)
            // MARK: 2x2 사이즈
            if family == .systemSmall {
                VStack {
                    HStack(alignment: .bottom) {
                        Text("\(weatherBoxData.currentTemperature) ")
                            .font(.IMHyemin(.title))
                            .tracking(-(Font.FontSize.title2.rawValue * 0.07))
                        Text("°")
                            .font(.IMHyemin(.title))
                            .padding(.leading, -(Font.FontSize.title2.rawValue * 0.5))
                        Text("\(weatherBoxData.weatherCondition.weatherString())")
                            .font(.IMHyemin(.caption2))
                            .padding(.leading, -10)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120.responsibleHeight)
                            .padding(.trailing, -20)
                    }
                }
            // MARK: 2x4 사이즈
            } else if family == .systemMedium {
                VStack {
                    HStack {
                        Text("\(weatherBoxData.weatherCondition.weatherComment(weatherData: dailyWeatherData))")
                            .font(.IMHyemin(.caption))
                            .IMHyeminLineHeight(.title, lineHeight: 10)
                        Spacer()
                    }
                }
            }
        } else {
            Text("정보 불러오기 실패. 앱을 실행해 보세요.")
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
                .containerBackground(Color.seaSky.secondary, for: .widget)
            //                .background(Color.seaSky)
        }.supportedFamilies([.systemSmall, .systemMedium])
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
