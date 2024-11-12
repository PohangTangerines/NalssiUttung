//
//  NoResultView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/4/24.
//

import SwiftUI

struct NoResultView: View {
    var body: some View {
        // TODO: - 뷰 살짝 위로 올리기
        VStack {
            Image("donut")
            Text("검색 결과가 없어요")
                .font(.IMHyemin(.body))
            Spacer()
        }
        .padding(.bottom, 30)
        .background(Color.seaSky)
    }
}

#Preview {
    NoResultView()
}
