//
//  DailyWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/16.
//

//import SwiftUI
//
//struct DailyWeatherView: View {
//    @Binding var dailyWeatherData: [DailyWeatherData]
//    var body: some View {
//        ScrollView(.horizontal) {
//                VStack(alignment: .leading) {
//                    VStack {
//                        HStack(spacing: 20) {
//                            ForEach(dailyWeatherData , id: \.time) {
//                                Text($0.time)
//                                    .font(.pretendardMedium(.footnote))
//                            }
//                        }
//                        .padding(.bottom, 12)
//                        HStack(spacing: 49) {
//                            ForEach(dailyWeatherData, id: \.time) {
//                                Image("\($0.weatherConditionIcon)")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(maxWidth: 28)
//                            }
//                        }
//                        .offset(x:-5)
//                    }
////                    DailyWeatherChartView(dailyWeatherData: $dailyWeatherData)
////                        .padding(.bottom, 20)
////                        .offset(x: -28,  y: 20)
//                    HStack(spacing: 52) {
//                        ForEach(dailyWeatherData, id: \.time) {
//                            Text("\($0.temperature)°")
//                                .font(.pretendardMedium(.footnote))
//                        }
//                    }
//                }
//            }
//            .padding(20)
//    }
//}
//
//struct DailyWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyWeatherView(dailyWeatherData: .constant(DailyWeatherData.sampleData))
//    }
//}
