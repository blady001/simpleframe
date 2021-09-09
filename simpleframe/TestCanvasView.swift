//
//  TestCanvasView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 09/09/2021.
//

import SwiftUI

struct TestCanvasView: View {
    @State private var image: Image?
    @State private var sliderValue: CGFloat = 0
    
    private func loadImage() {
        guard let inputImage = UIImage(named: "nikisz") else { return }
        let ciInputImage = CIImage(image: inputImage)!

        let baseRect = CGRect(x: -400, y: -200, width: 4000, height: 5000)
        let bgImage = CIImage(color: CIColor.green)

        let finalImage = ciInputImage.composited(over: bgImage)

        let context = CIContext()
        if let cgImg = context.createCGImage(finalImage, from: baseRect) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
            }
            Slider(value: $sliderValue, in: -500...0)
        }
        .onAppear(perform: loadImage)
    }
}

struct TestCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        TestCanvasView()
    }
}
