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
        NavigationView {
            VStack(spacing: 0) {
                informationHeader(dismiss, title: "날씨삼춘 알아보기")
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: 소개
                    rowTitle("소개")
                    informationNavigationRow(MakePeopleView(), title: "날씨삼춘을 만든 사람들")
                    informationNavigationRow(
                        WebView(urlToLoad: "https://lateral-donkey-cf6.notion.site/128ecf0613254204aec7d344285d121f?pvs=4"),
                        title: "할라프렌즈")
                    
                    // MARK: 정보
//                    rowTitle("정보").padding(.top, 6)
//                    informationNavigationRow(ResourcesView(), title: "데이터 리소스")
                    Spacer().frame(height: 30)
                    
                    // MARK: 데이터 리소스
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("날씨 데이터는  ")
                                    .font(.IMHyemin(.footnote))
                                    .foregroundColor(.black)
                                Image(systemName: "applelogo")
                                    .font(.system(size: 30))
                                    .padding(.bottom, 5)
                                Text(" Weather")
                                    .font(.system(size: 30, weight: .semibold))
                            }
                            
                            NavigationLink {
                                WebView(urlToLoad: "https://developer.apple.com/weatherkit/data-source-attribution/")
                            } label: {
                                Text("Other Apple Weather data sources")
                                    .font(.system(size: 15))
                                    .underline()
                                    .foregroundColor(.black)
                            }.padding()
                        }
                        Spacer()
                    }
                    
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
                }.padding(.bottom, 30)
            }.padding(.horizontal, 15)
                .background(Color.seaSky)
        }.toolbar(.hidden)
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
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
    }
}
