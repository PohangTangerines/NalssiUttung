//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI
import ScrollKit

struct MainView: View {
    @Binding var dailyWeatherData: DailyWeatherData?
    
    @State private var dragOffset: CGSize = .zero
    @State private var canTransition = false
    
    private var dragGesture: some Gesture {
        DragGesture()
              .onChanged { gesture in
                  withAnimation(.easeIn(duration: 0.5)) {
                      if gesture.translation.height < -100 {
                          canTransition = true
                      } else {
                          canTransition = false
                      }
                  }
              }
              .onEnded { gesture in
                  if gesture.translation.height < -100 {
                      // View 전환
                  }
              }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MainHeader()
                VStack(spacing: 0) {
                    tempConditionRow
                        .padding(.bottom, 10)
                    // TODO: tempConditionRow ~ 최고 최저 온도 사이 padding값 물어보기. (임시값 10)
                    
                    HStack {
                        Text("최고 \(33)° | 최저 \(24)°")
                            .font(.pretendardMedium(.body))
                        Spacer()
                    }.padding(.bottom, 18)
                    
                    ZStack {
                        VStack {
                            HStack {
                                Text("일교차 크난\n고뿔 들리지 않게\n조심합서!")
                                    .font(.IMHyemin(.title))
                                    .IMHyeminLineHeight(.title, lineHeight: 40)
                                Spacer()
                            }
                            Spacer()
                        }
                        VStack {
                            Spacer().frame(height: 50)
                            HStack {
                                Spacer()
                                Image("halla")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280)
                            }
                        }
                    }
                    
                    DailyWeatherView(dailyWeatherData: $dailyWeatherData)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 10)
                        .foregroundColor(.black)
                        .background {
                            Circle().frame(width: 40, height: 40)
                                .foregroundColor(canTransition ? Color.accentBlue : Color.clear)
                        }
                        .padding(.top, 42).padding(.bottom, 21)
                }.gesture(dragGesture)
        }.padding(.horizontal, 15)
            .offset(y: canTransition ? -50 : 0)
            .background(Color.seaSky)
    }
    
    private var tempConditionRow: some View {
        HStack(alignment: .bottom) {
            Text("24 ")
                .font(.IMHyemin(.largeTitle2))
                .tracking(-(Font.DEFontSize.largeTitle.rawValue * 0.1))
            Text("°")
                .font(.IMHyemin(.largeTitle))
                .padding(.leading, -(Font.DEFontSize.largeTitle2.rawValue * 0.5))
            Text("맑음")
                .font(.IMHyemin(.title))
                .padding(.bottom, 13)
                .padding(.leading, -30)
            Spacer()
        }
    }
}

struct MainHeader: View {
    let locationText: String = "제주시 애월읍"
    
    var body: some View {
        ZStack {
            HStack {
                Text("\(locationText)")
                    .font(.pretendardSemibold(.callout))
                Image(systemName: "location.fill")
                    .font(.system(size: 16, weight: .bold))
            }
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .font(.pretendardSemibold(.body))
            }
        }.padding(.top, 7.5).padding(.bottom, 12)
    }
}
