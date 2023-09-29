//
//  MainView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/10/01.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            MainHeader()
            Spacer()
            
            Text("24")
                .font(.IMHyemin(.largeTitle))
        }.padding(.horizontal, 15)
            .background(Color.seaSky)
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
