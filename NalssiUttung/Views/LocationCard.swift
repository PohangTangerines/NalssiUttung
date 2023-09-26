//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//

import SwiftUI

struct LocationCard: View {
    @Binding var weatherBoxData: WeatherBoxData?
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.seaSky)
                .frame(maxWidth: 350, maxHeight: 140)
            
            HStack(alignment: .bottom) {
                if let weatherBoxData = weatherBoxData {
                    VStack(alignment: .leading, spacing: 12) {
                        // MARK: Location
                        Text("\(weatherBoxData.location)")
                            .font(.system(size: 17))
                        
                        HStack {
                            Image("dayClear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minWidth: 60, minHeight: 60)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                // MARK: Forecast Temperature Range
                                Text("\(weatherBoxData.currentTemperature)°  흐림")
                                    .font(.system(size: 24))
                                    .bold()
                                
                                //                            // MARK: Forecast high low
                                Text("최저 \(weatherBoxData.lowestTemperature)도 | 최고 \(weatherBoxData.highestTemperature)도")
                                    .font(.system(size: 16))
                                    .lineLimit(1)
                            }
                        }
                    }
                } else {
                    Text("날씨 정보를 가져올 수 없습니다.")
                }
            }
            .foregroundColor(Color.darkChacoal)
            .padding(.vertical, 20)
            .padding(.leading, 20)
        }
        .frame(maxWidth: 350, maxHeight: 140, alignment: .bottom)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 2))
    }
}
