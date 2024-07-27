//
//  NalssiSamchunWidget.swift
//  NalssiSamchunWidget
//
//  Created by 금가경 on 7/17/24.
//

import SwiftUI
import WidgetKit
import Foundation

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weatherData: .placeholderData)
    }
    
    func getSnapshot(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), weatherData: .previewData)
        completion(entry)
    }
    
    func getTimeline(for configuration: AddressSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        
        Task {
            var entries: [SimpleEntry] = []
            let address = configuration.location?.displayString
            
            let weatherData = try? await WeatherWidgetData.currentWeather(for: address)
            let data = weatherData ?? .placeholderData
            
            for hourOffset in 0..<24 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, weatherData: data)
                entries.append(entry)
                
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
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
        IntentConfiguration(kind: kind, intent: AddressSelectionIntent.self, provider: Provider()) { entry in
            NalssiSamchunWidgetEntryView(entry: entry)
                .containerBackground(Color.seaSky, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    NalssiSamchunWidget()
} timeline: {
    SimpleEntry(date: .now, weatherData: .previewData)
}
