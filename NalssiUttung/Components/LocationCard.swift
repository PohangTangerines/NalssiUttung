//
//  Widget.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/09.
//
import SwiftUI

struct LocationCard: View {
    var Location = "제주시 아라동"
    var temperature  = 24
    var high = 33
    var low = 24

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow)
                .frame(width: 350, height: 140)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 12) {
                    // MARK: Location
                    Text("\(Location)")
                        .font(.system(size: 17))

                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                            .frame(minWidth: 60, minHeight: 60)

                        VStack(alignment: .leading, spacing: 2) {
                            // MARK: Forecast Temperature Range
                            Text("\(temperature)°  \(high)°")
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
            .foregroundColor(.black)
            .padding(.vertical, 20)
            .padding(.leading, 20)
        }
        .frame(width: 350, height: 140, alignment: .bottom)
    }
}

struct LocationCard_Previews: PreviewProvider {
    static var previews: some View {
        LocationCard()
            .preferredColorScheme(.dark)
    }
}
