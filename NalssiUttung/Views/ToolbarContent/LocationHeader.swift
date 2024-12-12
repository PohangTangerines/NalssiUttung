//
//  locationInfo.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct LocationHeader: View {
    let address: String
    let isCurrentLocation: Bool
    
    var body: some View {
        HStack {
            Text("\(address)")
                .font(.pretendardSemibold(.callout))
            
            if isCurrentLocation {
                Image(systemName: "location.fill")
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
}

#Preview {
    LocationHeader(address: "제주공항", isCurrentLocation: true)
}
