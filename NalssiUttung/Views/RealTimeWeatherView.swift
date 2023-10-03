//
//  RealTimeWeatherView.swift
//  NalssiUttung
//
//  Created by 금가경 on 2023/09/12.
//

import SwiftUI

struct RealTimeWeatherView: View {
    @Binding var realTimeWeather: RealTimeWeather
    @Binding var location: String

    var body: some View {
        NavigationView() {
            ZStack(alignment: .top) {
                Color.seaSky
                    .ignoresSafeArea()
                hallaPhoto
                    .padding(.top, 220)
                realTimeContent
                    .padding(.leading, 20.0)
                    .padding(.top, 9)
            }
            .navigationBarTitle(location, displayMode: .inline)
            .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text(location)
                                Image(systemName: "location.fill")
                                    .font(.system(size: 18))
                            }
                        }
                    }
            .navigationBarItems(trailing: Button(action: {
                // 버튼 클릭 시 실행할 코드
                print("Button Tapped")
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color.buttonBlue)
                    .font(.title)
            })
        }
    }

    private var hallaPhoto: some View{
        HStack {
            Spacer()
            Image("halla")
        }
    }

    private var realTimeContent: some View{
        return HStack(spacing: 0.0) {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("\(realTimeWeather.temperature)°")
                        .font(.system(size:80))
                        .padding(.bottom, -15.0)
                    Text("\(realTimeWeather.condition)")
                        .font(.system(size:26))
                }
                .padding(.bottom, 21)
                Text("최고 \(realTimeWeather.highTemperature)° | 최저 \(realTimeWeather.lowTemperature)°")
                    .font(.system(size:20))
                    .padding(.bottom, 24.0)
                Text("\(realTimeWeather.weatherMessage)")
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .font(.system(size:26))
            }
            Spacer()
        }
    }
}

struct RealTimeWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeWeatherView(realTimeWeather: .constant(RealTimeWeather.sampleData[0]), location: .constant("test"))
    }
}
