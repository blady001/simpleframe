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
    @State private var inputImage = UIImage(named: "nikisz")!
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: geometry.size.width)
                        .border(frameColor, width: calculateBorderWidth(viewportFrameWidth: geometry.size.width))
                    Spacer()
                    VStack {
                        ColorPicker("Select color", selection: $frameColor, supportsOpacity: false)
                        Slider(value: $frameSize, in: 0...10, step: 1)
                        Text("\(Int(frameSize))")
                    }.padding()
                }
            }.padding(.top)
            .navigationBarTitle("Add frame", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                        print("clicked")
                }) {
                    Image(systemName: "square.and.arrow.down").imageScale(.large)
                })
        }
    }
    
    func calculateBorderWidth(viewportFrameWidth: CGFloat) -> CGFloat {
        return frameSize * viewportFrameWidth / 200
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
