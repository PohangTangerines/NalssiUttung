//
//  AppIntent.swift
//  NalssiSamchunWidget
//
//  Created by 금가경 on 7/17/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("2*2 위젯입니다.")

    @Parameter(title: "지역을 선택해주세요.", default: "제주공항")
    var favoriteEmoji: String
}
