//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//
import SwiftUI

struct LocationCard: View {
    var location = "제주시 아라동"
    var temperature  = 24
    var high = 33
    var low = 24

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.seaSky)
                .frame(maxWidth: 350, maxHeight: 140)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 12) {
                    // MARK: Location
                    Text("\(location)")
                        .font(.system(size: 17))

                    HStack {
                        Image("dayClear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 60, minHeight: 60)

                        VStack(alignment: .leading, spacing: 2) {
                            // MARK: Forecast Temperature Range
                            Text("\(temperature)°  흐림")
                                .font(.system(size: 24))
                                .bold()

                            // MARK: Forecast high low
                            Text("최저 \(low)도 | 최고 \(high)도")
                                .font(.system(size: 16))
                                .lineLimit(1)
                        }
                    }
                }
            }
            .foregroundColor(Color.darkChacoal)
            .padding(.vertical, 20)
            .padding(.leading, 20)
        }
        .frame(maxWidth: 350, maxHeight: 140, alignment: .bottom)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 2))
    }
}

struct LocationCard_Previews: PreviewProvider {
    static var previews: some View {
        LocationCard()
            .preferredColorScheme(.dark)
    }
}
