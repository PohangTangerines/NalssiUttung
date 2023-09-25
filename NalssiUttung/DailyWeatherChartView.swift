//
//  DailyWeatherChartView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/16.
//

//import SwiftUI
//import Charts
//
//struct DailyWeatherChartView: View {
//    @Binding var dailyWeatherData: [DailyWeatherData]
//
//    var body: some View {
//        VStack {
//            Chart {
//                ForEach(dailyWeatherData, id: \.time) {
//                    LineMark(
//                        x: .value("index", $0.time),
//                        y: .value("value", $0.temperature)
//                    )
//                    .foregroundStyle(.black)
//                    PointMark(
//                        x: .value("index", $0.time),
//                        y: .value("value", $0.temperature)
//                    )
//                    .symbol {
//                        Circle()
//                            .fill(Color.white)
//                            .overlay(
//                                Circle()
//                                    .stroke(Color.black, lineWidth: 2))
//                            .frame(width: 8)
//                    }
//                }
//            }
//        }
//        .chartYAxis(.hidden)
//        .chartXAxis(.hidden)
//        .aspectRatio(17.4, contentMode: .fit)
//        .frame(height: 27)
//    }
//}
//struct DailyWeatherChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyWeatherChartView(dailyWeatherData: .constant(DailyWeatherData.sampleData))
//    }
//}
