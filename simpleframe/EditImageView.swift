//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 10/09/2021.
//

import SwiftUI


struct EditImageView: View {
    @State private var frameColor = Color.red
    @State private var frameSizeSliderValue: CGFloat = 0
    
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
                        if let imageView = imageView {
                            imageView.resizable()
                                .scaledToFit()
                                .border(frameColor, width: calculateViewportBorderWidth(viewportFrameWidth: geometry.size.width))
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
                        Slider(value: $frameSizeSliderValue, in: 0...10, step: 1)
                        Text("\(Int(frameSizeSliderValue))")
                    }.padding()
                }
            }
            .navigationBarTitle("SimpleFrame", displayMode: .inline)
            .navigationBarItems( // TODO: replace with toolbar
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
    
    private func calculateViewportBorderWidth(viewportFrameWidth: CGFloat) -> CGFloat {
        return frameSizeSliderValue * viewportFrameWidth / 200
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
        
        // TODO: Add error handling
        DispatchQueue.global(qos: .userInitiated).async {
            let outputImage = processImage(image: beginImage, viewportWidth: relativeScreenWidth)
            saveImage(outputImage)
            DispatchQueue.main.async {
                self.isSaving.toggle()
            }
        }
    }
    
    private func processImage(image: UIImage, viewportWidth: CGFloat) -> UIImage {
        func convertToCgColor(_ color: Color) -> CGColor {
            UIColor(color).cgColor
        }
        let processor = ImageProcessor()
        let viewportBorderWidth = calculateViewportBorderWidth(viewportFrameWidth: viewportWidth)
        let borderColor = convertToCgColor(frameColor)
        let outputImage = processor.addBorders(inputImage: image, screenWidth: viewportWidth, screenBorderWidth: viewportBorderWidth, borderColor: borderColor)
        return outputImage
    }
    
    private func saveImage(_ image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
    }
}

struct EditImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditImageView()
    }
}
