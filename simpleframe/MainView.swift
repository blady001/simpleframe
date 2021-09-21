//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 10/09/2021.
//

import SwiftUI

struct PreviewImageView: View {
    @Binding var isPresented: Bool
    let inputImage: UIImage?
    @State private var imageView: Image?
    
    var body: some View {
        VStack {
            Button("Press to dismiss") {
                isPresented = false
            }
            if let imageView = imageView {
                imageView
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView("Processing...")
            }
        }
        .onAppear(perform: loadImageInBackground)
        .padding()
    }
    
    //    private func loadImage() {
    //        let borderWidth: CGFloat = 100.0
    //        let size = inputImage.size
    //        UIGraphicsBeginImageContext(size)
    //        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
    //        inputImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
    //
    //        let context = UIGraphicsGetCurrentContext()
    //        let borderRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
    //
    //        context?.setStrokeColor(CGColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0))
    //        context?.setLineWidth(100.0)
    //        context?.stroke(borderRect)
    //
    //        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        if let oi = outputImage {
    //            displayedImage = Image(uiImage: oi)
    //        }
    //    }
    
    private func loadImageInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let processedImage = self.loadImageBetter() {
                DispatchQueue.main.async {
                    self.imageView = Image(uiImage: processedImage)
                }
            }
        }
    }
    
    private func loadImageBetter() -> UIImage? {
        guard let inputImage =  inputImage else { return nil }
        
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
        
        return outputImage
    }
}

struct MainView: View {
    @State private var frameColor = Color.red
    @State private var frameSize: CGFloat = 0
    @State private var inputImage: UIImage?
    @State private var imageView: Image?
    @State private var showingImagePicker = false
    @State private var previewImage = false
    @State private var discardDisabled = true
    @State private var showingDiscardConfirmationAlert = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                        
                        if let imageView = imageView {
                            imageView.resizable()
                                .scaledToFit()
                                .border(frameColor, width: calculateBorderWidth(viewportFrameWidth: geometry.size.width))
                        } else {
                            Button("Select image") {
                                showingImagePicker.toggle()
                            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                            }
                        }
                    }
                    
                    Spacer()
                    VStack {
                        ColorPicker("Select color", selection: $frameColor, supportsOpacity: false)
                        Slider(value: $frameSize, in: 0...10, step: 1)
                        Text("\(Int(frameSize))")
                    }.padding()
                }
            }
            .navigationBarTitle("Add frame", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        showingDiscardConfirmationAlert = true
                    }) {
                        Image(systemName: "xmark").imageScale(.large)
                    }.disabled(discardDisabled),
                trailing:
                    Button(action: {
                        previewImage.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.down").imageScale(.large)
                    })
            .sheet(isPresented: $previewImage) {
                PreviewImageView(isPresented: $previewImage, inputImage: inputImage)
            }
            .alert(isPresented: $showingDiscardConfirmationAlert) {
                Alert(title: Text("Discard?"),
                      message: Text("All changes will be lost."),
                      primaryButton: .destructive(Text("Confirm")) {
                        discardImage()
                      },
                      secondaryButton: .default(Text("Cancel"))
                )
            }
        }
    }
    
    private func loadImage() {
        guard let inputImage =  inputImage else { return }
        imageView = Image(uiImage: inputImage)
        discardDisabled = false
    }
    
    private func calculateBorderWidth(viewportFrameWidth: CGFloat) -> CGFloat {
        return frameSize * viewportFrameWidth / 200
    }
    
    private func discardImage() {
        imageView = nil
        inputImage = nil
        discardDisabled.toggle()
    }
    
    private func saveImage() {
        // TODO: start here - actually process image in background -> MAYBE ON A PROGRESS SHEET FOR NOW? -> would be kinda easier (create sheet responsible for processing the image)
        guard let processedImage = inputImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
