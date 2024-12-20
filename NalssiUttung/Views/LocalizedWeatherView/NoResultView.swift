//
//  NoResultView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/4/24.
//

import SwiftUI

struct NoResultView: View {
    var body: some View {
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
            Spacer()
        }
        .padding(.bottom, 180.responsibleHeight)
        .background(Color.seaSky)
    }
}

#Preview {
    NoResultView()
}
