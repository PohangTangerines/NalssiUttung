//
//  AnimatedSplashGifView.swift
//  NalssiUttung
//
//  Created by been on 11/12/23.
//

import SwiftUI
import Gifu

struct AnimatedSplashGifView: UIViewRepresentable {
    @Binding var gifName: String
    
    @State private var imageView = GIFImageView(frame: CGRect(x: (UIScreen.main.bounds.width - 198) / 2, y: (UIScreen.main.bounds.height - 182) / 2.5, width: 198, height: 182))

//    @State private var imageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 198, height: 182))
    
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
//    AnimatedSplashGifView()
//}
