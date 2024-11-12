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
    
    @State private var dragOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    
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
                    .gesture(DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { _ in
                            if dragOffset > 50 {
                                dismiss()
                            }
                            dragOffset = 0
                        }
                    )
            }
            .padding(.top, 15)
            .padding(20)
        }
    }
}

/// customNavigationBar를 구현했습니다. 아래에 SearchBar를 달고싶었는데, toolbar로는 구현이 불가능해서 따로 구현했습니다.
extension View {
    func customNavigationBar(toolbarViewModel: ToolbarViewModel, localizedWeatherViewModel: LocalizedWeatherViewModel) -> some View {
        self.modifier(CustomNavigationBarModifier(leading: NavigationBarBackButton(),
                                                  principal: AddLocationText(),
                                                  trailing: EditButton(localizedWeatherViewModel: localizedWeatherViewModel),
                                                  bottom: SearchBar(toolbarViewModel: toolbarViewModel)))
    }
}
