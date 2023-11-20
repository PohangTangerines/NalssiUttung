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
                rowTitle("소개")
                informationNavigationRow(InformationView(), title: "날씨삼춘을 만든 사람들")
                informationNavigationRow(InformationView(), title: "할라프렌즈")
                
                // MARK: 정보
                rowTitle("정보")
                informationNavigationRow(InformationView(), title: "데이터 리소스")
                
                Spacer()
            }
            
            // MARK: 기여운 캐릭터들
            VStack(alignment: .center) {
                Image("hallaFriends")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 350)
                    .frame(height: 230)
            }
        }.padding(.horizontal, 15)
        .background(Color.seaSky)
            .toolbar(.hidden)
    }
    
    private func rowTitle(_ title: String) -> some View {
        return Text(title).font(.pretendardMedium(.caption2))
            .foregroundColor(.darkChacoal)
            .padding(.bottom, 12)
    }
    
    private func informationNavigationRow(_ viewLink: some View, title: String) -> some View {
        return VStack(spacing: 0) {
            NavigationLink(destination: viewLink) {
                HStack {
                    Text(title)
                        .font(.pretendardMedium(.footnote))
                        .foregroundColor(.black)
                    Spacer()
                    chervronRight
                }
            }
            divider
        }
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
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer().frame(width: 40)
        }
    }.padding(.top, 7.5).padding(.bottom, 24)
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
