//
//  ResourcesView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

struct ResourcesView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            informationHeader(dismiss, title: "데이터 리소스")
                .padding(.bottom, 6)
            
            HStack(alignment: .center, spacing: 0) {
                Text("날씨 데이터는  ")
                    .font(.IMHyemin(.footnote))
                    .foregroundColor(.black)
                Image(systemName: "applelogo")
                    .font(.system(size: 30))
                    .padding(.bottom, 7)
                Text(" Weather")
                    .font(.system(size: 30, weight: .semibold))
            }
            
            NavigationLink {
                WebView(urlToLoad: "https://developer.apple.com/weatherkit/data-source-attribution/")
            } label: {
                Text("other data sources")
                    .underline()
                    .foregroundColor(.black)
            }.padding()
            
            Spacer()
        }.padding(.horizontal, 15)
            .background(Color.seaSky)
            .toolbar(.hidden)
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}
