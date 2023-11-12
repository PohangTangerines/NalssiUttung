//
//  AnimatedGifView.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/23.
//

import SwiftUI
import Gifu

struct AnimatedGifView: UIViewRepresentable {
    @Binding var gifName: String
    @State private var imageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 280, height: 280))
    
    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        uiView.addSubview(imageView)
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        imageView.animate(withGIFNamed: gifName)
    }
}

//#Preview {
//    AnimatedGifView(gifName: .constant("clearCharacter"))
//}
