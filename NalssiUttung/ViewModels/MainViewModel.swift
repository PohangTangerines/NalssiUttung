//
//  MainViewModel.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/30/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
//    // MARK: UI 관련 Property
//    @Published var gifName: String = "cl"
    // MARK: View 전환, Gesture 관련 Property
    @Published var displayedContent: DisplayedContent = .main
    @Published var dragOffset: CGSize = .zero
    @Published var canTransition = false
    @Published var viewOffsetY: CGFloat = 0

    func handleDragGesture(_ gesture: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.5)) {
            switch displayedContent {
            case .main:
                if gesture.translation.height < -100 {
                    canTransition = true
                    viewOffsetY = -100
                } else {
                    canTransition = false
                    viewOffsetY = 0
                }
            case .detail:
                if gesture.translation.height > 100 {
                    canTransition = true
                    viewOffsetY = 100
                } else {
                    canTransition = false
                    viewOffsetY = 0
                }
            }
        }
    }
    
    func endDragGesture(_ gesture: DragGesture.Value) {
        withAnimation {
            viewOffsetY = 0
            canTransition = false
            switch displayedContent {
            case .main:
                if gesture.translation.height < -100 {
                    displayedContent = .detail
                }
            case .detail:
                if gesture.translation.height > 100 {
                    displayedContent = .main
                }
            }
        }
    }
}
