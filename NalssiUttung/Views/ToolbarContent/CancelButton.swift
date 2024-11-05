//
//  CancelButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct CancelButton: View {
    var mode: WeatherDisplayMode
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("취소")
                .font(.pretendardSemibold(.body))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    CancelButton(mode: .modal)
}
