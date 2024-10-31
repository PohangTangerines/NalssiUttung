//
//  locationInfo.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct CurrentLocation: View {
    let location: String
    
    var body: some View {
        HStack {
            Text("\(location)")
                .font(.pretendardSemibold(.callout))
            Image(systemName: "location.fill")
                .font(.system(size: 16, weight: .bold))
        }
    }
}

#Preview {
    CurrentLocation(location: "제주공항")
}
