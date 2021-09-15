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
    @State private var inputImage = UIImage(named: "nikisz")!

    private var ciContext = CIContext()
    private var ciFilter = CIFilter(name: "CISourceOverCompositing")!
    private let bgImageBase = CIImage(color: CIColor.green)
    
    private func loadImage() {
        let ciInputImage = CIImage(image: inputImage)!

        let baseRect = CGRect(x: sliderValue, y: -100, width: 4000, height: 5000)
        let bgImage = bgImageBase.cropped(to: baseRect)

//        let context = CIContext()
//        let filter = CIFilter(name: "CISourceOverCompositing")!
        ciFilter.setValue(bgImage, forKey: kCIInputBackgroundImageKey)
        ciFilter.setValue(ciInputImage, forKey: kCIInputImageKey)
        guard let outputImage = ciFilter.outputImage else { return }
        
        if let cgImg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
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
            Slider(value: $sliderValue, in: -500...0) { hasChanged in
                loadImage()
            }
        }
        .onAppear(perform: loadImage)
    }
}

struct TestCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        TestCanvasView()
    }
}
