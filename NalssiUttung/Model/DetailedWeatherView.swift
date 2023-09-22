//
//  DetailedWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/19.
//

import SwiftUI

struct DetailedWeatherView: View {
    @Binding var detailedWeatherData: DetailedWeatherData
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                Rectangle()
                    .frame(maxHeight: 2)
                Text("상세 날씨")
                    .font(.IMHyemin(.footnote))
                Rectangle()
                    .frame(maxHeight: 2)
            }
            
            HStack(spacing: 40.0) {
                VStack(spacing: 8) {
                    Text("강수량")
                        .font(.pretendardMedium(.caption))
                    Image("precipitation")
                        .resizable()
                        .scaledToFit()
                        .frame(width:36)
                    Text("없음")
                        .font(.pretendardMedium(.footnote))
                    Text("\(detailedWeatherData.precipitation)mm")
                        .font(.pretendardMedium(.caption))
                }
                Rectangle()
                    .frame(maxWidth: 2)
                VStack(spacing: 8) {
                    Text("바람")
                        .font(.pretendardMedium(.caption))
                    Image("windy")
                        .resizable()
                        .scaledToFit()
                        .frame(width:36)
                    Text("\(detailedWeatherData.wind)")
                        .font(.pretendardMedium(.footnote))
                    Text("\(String(format: "%.1f", detailedWeatherData.windSpeed))m/s")
                        .font(.pretendardMedium(.caption))
                }
                Rectangle()
                    .frame(maxWidth: 2)
                VStack(spacing: 8) {
                    Text("가시거리")
                        .font(.pretendardMedium(.caption))
                    Image("visibility")
                        .resizable()
                        .scaledToFit()
                        .frame(width:36)
                    Text("\(detailedWeatherData.visibilityState)")
                        .font(.pretendardMedium(.footnote))
                    Text("\(detailedWeatherData.visibility)km")
                        .font(.pretendardMedium(.caption))
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: 172)
    }
}

    struct DetailedWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedWeatherView(detailedWeatherData: .constant(DetailedWeatherData.sampleData[0]))
    }
}
