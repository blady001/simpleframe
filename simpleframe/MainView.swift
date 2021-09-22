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
    
    @State private var inputImage: UIImage?
    @State private var imageView: Image?
    
    @State private var showingImagePicker = false
    @State private var discardDisabled = true
    @State private var showingDiscardConfirmationAlert = false
    @State private var showingImageSavingView = false
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .scaledToFit()
//                            .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                        
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
                    }.frame(maxHeight: geometry.size.width)
                    
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
                        processAndSaveImage()
                    }) {
                        Image(systemName: "square.and.arrow.down").imageScale(.large)
                    })
            .sheet(isPresented: $showingImageSavingView) {
                ImageSavingView(isPresented: $showingImageSavingView, isSaving: $isSaving)
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
    
    private func processAndSaveImage() {
        guard let beginImage = inputImage else { return }
        let relativeScreenWidth = UIScreen.main.bounds.width
        
        showingImageSavingView.toggle()
        isSaving.toggle()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let outputImage = processImage(image: beginImage, screenWidth: relativeScreenWidth)
            saveImage(outputImage)
            DispatchQueue.main.async {
                self.isSaving.toggle()
            }
        }
    }
    
    private func processImage(image: UIImage, screenWidth: CGFloat) -> UIImage {
        func convertToCgColor(_ color: Color) -> CGColor {
            UIColor(color).cgColor
        }
        let processor = ImageProcessor()
        let outputImage = processor.addBorders(inputImage: image, screenWidth: screenWidth, screenBorderWidth: calculateBorderWidth(viewportFrameWidth: screenWidth), borderColor: convertToCgColor(frameColor))
        return outputImage
    }
    
    private func saveImage(_ image: UIImage) {
        // TODO: start here - actually process image in background -> MAYBE ON A PROGRESS SHEET FOR NOW? -> would be kinda easier (create sheet responsible for processing the image)
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
