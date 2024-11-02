//
//  CancelButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct CancelButton: View {
    @Binding var isModalPresented: Bool
    var mode: WeatherDisplayMode
    
    var body: some View {
        Button {
            isModalPresented = false
            print("dismiss")
        } label: {
            Text("취소")
                .font(.pretendardSemibold(.body))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    CancelButton(isModalPresented: .constant(true), mode: .modal)
}
