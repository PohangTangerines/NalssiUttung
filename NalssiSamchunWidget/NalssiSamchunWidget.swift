//
//  NalssiSamchunWidget.swift
//  NalssiSamchunWidget
//
//  Created by 금가경 on 7/17/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), weatherData: .placeholderData)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, weatherData: .previewData)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
            var entries: [SimpleEntry] = []
            let currentDate = Date()

            let weatherData = try? await WeatherWidgetData.currentWeather()
        
            for hourOffset in 0..<24 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, configuration: configuration, weatherData: weatherData ?? .placeholderData)
                entries.append(entry)
            }
            return Timeline(entries: entries, policy: .atEnd)
        }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let weatherData: WeatherWidgetData
}

struct NalssiSamchunWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        RealTimeWeatherCharacterWidgetView(data: entry.weatherData)
    }
}

struct NalssiSamchunWidget: Widget {
    let kind: String = "NalssiSamchunWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            NalssiSamchunWidgetEntryView(entry: entry)
                .containerBackground(Color.seaSky, for: .widget)
        }
        .supportedFamilies([.systemSmall])
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

#Preview(as: .systemSmall) {
    NalssiSamchunWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, weatherData: .previewData)
}
