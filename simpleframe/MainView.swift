//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 10/09/2021.
//

import SwiftUI

struct PreviewImageView: View {
    @Environment(\.presentationMode) var presentationMode
    let inputImage: UIImage
    @State private var displayedImage: Image?
    
    var body: some View {
        VStack {
            Button("Press to dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
            displayedImage?
                .resizable()
                .scaledToFit()
//                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.onAppear(perform: loadImageBetter)
        .padding()
    }
    
    private func loadImage() {
        let borderWidth: CGFloat = 100.0
        let size = inputImage.size
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        inputImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        let borderRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        context?.setStrokeColor(CGColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0))
        context?.setLineWidth(100.0)
        context?.stroke(borderRect)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let oi = outputImage {
            displayedImage = Image(uiImage: oi)
        }
    }
    
    private func loadImageBetter() {
        let borderWidth: CGFloat = 100.0
        let size = inputImage.size
        let imgRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        let borderRect = imgRect.insetBy(dx: 2.0, dy: 2.0)
        let renderer = UIGraphicsImageRenderer(size: size)
        let outputImage = renderer.image { ctx in
            ctx.cgContext.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))

            ctx.cgContext.draw(inputImage.cgImage!, in: imgRect)
            
            ctx.cgContext.setStrokeColor(CGColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0))
            ctx.cgContext.setLineWidth(borderWidth)
            ctx.stroke(imgRect)
            
        }
        
        displayedImage = Image(uiImage: outputImage)
    }
}

struct MainView: View {
    @State private var frameColor = Color.red
    @State private var frameSize: CGFloat = 0
    @State private var inputImage = UIImage(named: "nikisz")!
    @State private var previewImage = false
    
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
                    previewImage.toggle()
                }) {
                    Image(systemName: "square.and.arrow.down").imageScale(.large)
                })
            .sheet(isPresented: $previewImage) {
                PreviewImageView(inputImage: inputImage)
            }
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
