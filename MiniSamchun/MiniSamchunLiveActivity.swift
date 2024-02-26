//
//  MiniSamchunLiveActivity.swift
//  MiniSamchun
//
//  Created by 이재원 on 2/27/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import WeatherKit

struct MiniSamchunAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MiniSamchunLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MiniSamchunAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MiniSamchunAttributes {
    fileprivate static var preview: MiniSamchunAttributes {
        MiniSamchunAttributes(name: "World")
    }
}

extension MiniSamchunAttributes.ContentState {
    fileprivate static var smiley: MiniSamchunAttributes.ContentState {
        MiniSamchunAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MiniSamchunAttributes.ContentState {
         MiniSamchunAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: MiniSamchunAttributes.preview) {
//   MiniSamchunLiveActivity()
//} contentStates: {
//    MiniSamchunAttributes.ContentState.smiley
//    MiniSamchunAttributes.ContentState.starEyes
//}
