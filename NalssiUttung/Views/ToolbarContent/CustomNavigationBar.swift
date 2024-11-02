//
//  CustomNavigationBar.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//
import SwiftUI

extension View {
    func customNavigationBar(toolbarViewModel: ToolbarViewModel) -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationBarBackButton()
                }
                
                ToolbarItem(placement: .principal) {
                    Text("지역 추가하기")
                        .font(.pretendardSemibold(.callout))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton(toolbarViewModel: toolbarViewModel)
                }
            }
    }
}
