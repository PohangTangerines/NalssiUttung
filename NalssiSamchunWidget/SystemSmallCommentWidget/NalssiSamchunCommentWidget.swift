//
//  NalssiSamchunCommentWidget.swift
//  NalssiSamchunWidgetExtension
//
//  Created by 금가경 on 7/29/24.
//

import SwiftUI
import WidgetKit
import Foundation

struct WeatherCommentWidgetProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WetherCommentWidgetEntry {
        WetherCommentWidgetEntry(date: Date(), weatherData: .previewData)
    }
    
    func getSnapshot(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (WetherCommentWidgetEntry) -> Void) {
        let entry = WetherCommentWidgetEntry(date: Date(), weatherData: .previewData)
        completion(entry)
    }
    
    func getTimeline(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (Timeline<WetherCommentWidgetEntry>) -> Void) {
        Task {
            let currentDate = Date()
            var entries: [WetherCommentWidgetEntry] = []
            let address = configuration.location?.displayString
            
            let weatherData = try? await WeatherCommentWidgetData.currentWeather(for: address)
            let data = weatherData ?? .failData
            
            for hourOffset in 0..<24 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = WetherCommentWidgetEntry(date: entryDate, weatherData: data)
                entries.append(entry)
                
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct WetherCommentWidgetEntry: TimelineEntry {
    let date: Date
    let weatherData: WeatherCommentWidgetData
}

struct NalssiSamchunCommentWidgetEntryView : View {
    var entry: WeatherCommentWidgetProvider.Entry

    var body: some View {
        RealTimeWeatherCommentWidgetView(data: entry.weatherData)
    }
}

struct NalssiSamchunCommentWidget: Widget {
    let kind: String = "NalssiSamchunCommentWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: AddressSelectionIntent.self, provider: WeatherCommentWidgetProvider()) { entry in
            NalssiSamchunCommentWidgetEntryView(entry: entry)
                .containerBackground(Color.seaSky, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    NalssiSamchunCommentWidget()
} timeline: {
    WetherCommentWidgetEntry(date: .now, weatherData: .previewData)
}
