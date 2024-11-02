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
                    HStack {
                        leading
                        principal
                        trailing
                    }
                    .padding(.bottom, 34.responsibleHeight)
                    bottom
                }
                .navigationBarBackButtonHidden(true)
                .frame(maxHeight: 84.responsibleHeight)
                content
            }
            .padding(20)
        }

    }
}

extension View {
    func customNavigationBar(toolbarViewModel: ToolbarViewModel) -> some View {
        self.modifier(CustomNavigationBarModifier(leading: NavigationBarBackButton(), principal: AddLocationText(), trailing: EditButton(toolbarViewModel: toolbarViewModel), bottom: SearchBar(toolbarViewModel: toolbarViewModel)))
    }
}
