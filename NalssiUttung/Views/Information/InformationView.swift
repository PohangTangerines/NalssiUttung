//
//  InformationView.swift
//  NalssiUttung
//
//  Created by 이재원 on 2023/11/20.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            informationHeader(dismiss, title: "날씨삼춘 알아보기")
            VStack(alignment: .leading, spacing: 0) {
                // MARK: 소개
                Text("소개").font(.pretendardMedium(.caption2))
                    .foregroundColor(.darkChacoal)
                    .padding(.bottom, 12)
                
                HStack {
                    Text("날씨삼춘을 만든 사람들")
                        .font(.pretendardMedium(.footnote))
                    Spacer()
                    chervronRight
                }
                divider
                HStack {
                    Text("할라프렌즈")
                        .font(.pretendardMedium(.footnote))
                    Spacer()
                    chervronRight
                }
                divider
                
                // MARK: 정보
                Text("정보").font(.pretendardMedium(.caption2))
                    .foregroundColor(.darkChacoal)
                    .padding(.top, 6)
                    .padding(.bottom, 12)
                
                HStack {
                    Text("데이터 리소스")
                        .font(.pretendardMedium(.footnote))
                    Spacer()
                    chervronRight
                }
                
                // MARK: 기여운 캐릭터들
            }
            Spacer()
        }.padding(.horizontal, 15)
        .background(Color.seaSky)
            .toolbar(.hidden)
    }
    
    private var chervronRight: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(Color.black)
            .frame(maxWidth: 8, maxHeight: 14)
    }
    
    private var divider: some View {
        Divider()
            .foregroundColor(.darkChacoal)
            .frame(height: 0.5)
            .padding(.vertical, 12)
    }
}

func informationHeader(_ dismiss: DismissAction, title: String) -> some View {
    return VStack {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18).weight(.medium))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
            }
            Text(title)
                .font(.pretendardSemibold(.callout))
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            Spacer().frame(width: 40)
        }
    }.padding(.top, 7.5).padding(.bottom, 24)
}
