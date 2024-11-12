//
//  CustomNavigationBar.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//
import SwiftUI

struct CustomNavigationBarModifier<L: View, P: View, R: View, B: View>: ViewModifier {
    let leading: L
    let principal: P
    let trailing: R
    let bottom: B
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            VStack {
                VStack {
                    ZStack {
                        principal
                        HStack(alignment: .center) {
                            leading
                            Spacer()
                            trailing
                        }
                    }
                    .padding(.bottom, 34.responsibleHeight)
                    bottom
                }
                .navigationBarBackButtonHidden(true)
                .frame(maxHeight: 84.responsibleHeight)
                content
            }
            .padding(.top, 15)
            .padding(20)
        }

    }
}

// TODO: - 슬라이딩 하면 pop하도록 조정
extension View {
    func customNavigationBar(toolbarViewModel: ToolbarViewModel) -> some View {
        self.modifier(CustomNavigationBarModifier(leading: NavigationBarBackButton(), principal: AddLocationText(), trailing: EditButton(), bottom: SearchBar(toolbarViewModel: toolbarViewModel)))
    }
}
