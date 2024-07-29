//
//  NalssiSamchunWidget.swift
//  NalssiSamchunWidget
//
//  Created by 금가경 on 7/17/24.
//

import SwiftUI
import WidgetKit
import Foundation

struct WeatherCharacterWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WetherCharacterWidgetEntry {
        WetherCharacterWidgetEntry(date: Date(), weatherData: .placeholderData)
    }
    
    func getSnapshot(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (WetherCharacterWidgetEntry) -> Void) {
        let entry = WetherCharacterWidgetEntry(date: Date(), weatherData: .previewData)
        completion(entry)
    }
    
    func getTimeline(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (Timeline<WetherCharacterWidgetEntry>) -> Void) {
        Task {
            let currentDate = Date()
            var entries: [WetherCharacterWidgetEntry] = []
            let address = configuration.location?.displayString
            
            let weatherData = try? await WeatherCharacterWidgetData.currentWeather(for: address)
            let data = weatherData ?? .placeholderData
            
            for hourOffset in 0..<24 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = WetherCharacterWidgetEntry(date: entryDate, weatherData: data)
                entries.append(entry)
                
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct WetherCharacterWidgetEntry: TimelineEntry {
    let date: Date
    let weatherData: WeatherCharacterWidgetData
}

struct NalssiSamchunCharacterWidgetEntryView : View {
    var entry: WeatherCharacterWidgetProvider.Entry

    var body: some View {
        RealTimeWeatherCharacterWidgetView(data: entry.weatherData)
    }
}

struct NalssiSamchunCharacterWidget: Widget {
    let kind: String = "NalssiSamchunCharacterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: AddressSelectionIntent.self, provider: WeatherCharacterWidgetProvider()) { entry in
            NalssiSamchunCharacterWidgetEntryView(entry: entry)
                .containerBackground(Color.seaSky, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    NalssiSamchunCharacterWidget()
} timeline: {
    WetherCharacterWidgetEntry(date: .now, weatherData: .previewData)
}
