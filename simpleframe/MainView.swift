//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 10/09/2021.
//

import SwiftUI

struct MainView: View {
    @State private var frameColor = Color.red
    @State private var frameSize: CGFloat = 0
    @State private var inputImage = UIImage(named: "nikisz")! {
        didSet {
            self.imageWidth = inputImage.size.width
            self.imageHeight = inputImage.size.height
        }
    }
    @State private var imageWidth: CGFloat?
    @State private var imageHeight: CGFloat?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .border(frameColor, width: frameSize)
                Spacer()
                VStack {
                    ColorPicker("Select color", selection: $frameColor)
                    Slider(value: $frameSize, in: 0...10, step: 1)
                    Text("\(Int(frameSize))")
                }.padding()
            }
        }
    }
    
//    func calculateBorderWidth() -> CGFloat {
//        return frameSize * viewportFrameSize / 100
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
