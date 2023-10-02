//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(spacing: 0) {
            MainHeader()
            
            tempConditionRow
                .padding(.bottom, 10)
            
            HStack {
                Text("최고 \(33)° | 최저 \(24)°")
                    .font(.pretendardMedium(.body))
                Spacer()
            }.padding(.bottom, 18)
            
            HStack {
                Text("일교차 크난\n고뿔 들리지 않게\n조심합서!")
                    .font(.IMHyemin(.title))
                    .IMHyeminLineHeight(.title, lineHeight: 40)
                Spacer()
            }
            
            Spacer()
        }.background(Color.seaSky).padding(.horizontal, 15)
            .background(Color.pink)
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
            .background(Color.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
