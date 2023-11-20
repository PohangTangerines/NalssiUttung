//
//  MakePeopleView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/11/20.
//

import SwiftUI

struct MakePeopleView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            informationHeader(dismiss, title: "날씨삼춘을 만든 사람들")
            
            Image("makePeople")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(height: 578)
            
            Spacer()
            
            VStack {
                Text("Team Pohang Tangerines")
                Text("Apple Developer Academy @ POSTECH 2nd")
            }.font(.pretendardMedium(.caption2))
                .foregroundColor(.darkChacoal)
                .padding(.bottom, 30)
            
        }.padding(.horizontal, 15)
            .background(Color.seaSky)
            .toolbar(.hidden)
    }
}

struct MakePeopleView_Previews: PreviewProvider {
    static var previews: some View {
        MakePeopleView()
    }
}
