//
//  ScrollDownIndicator.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/6/24.
//
import SwiftUI

struct ScrollDownIndicator: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Image(systemName: "chevron.down")
            .resizable()
            .scaledToFit()
            .frame(height: 10.responsibleWidth)
            .foregroundStyle(.black)
            .background {
                Circle()
                    .frame(width: 40.responsibleWidth, height: 40.responsibleWidth)
                    .foregroundStyle(viewModel.canTransition ? Color.accentBlue: Color.clear)
            }
            .padding(.bottom, 21.responsibleHeight)
    }
}
