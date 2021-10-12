//
//  BorderAddingView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 09/10/2021.
//

import SwiftUI

struct BorderAddingView: View {
    
//    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingDismissAlert = false
    @State private var showingSavingResultBanner = false
    @State private var bannerData = BannerModifier.BannerData(title: "Success!", detail: "Photo saved to gallery.", type: .success)
    @State private var isSaving = false
    @State private var shouldAskBeforeDismissing = false
    
    @State private var frameColor = Color.black
    @State private var frameSizeSliderValue: CGFloat = 0
    @Binding var image: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    VStack {
                        Spacer()
                        HStack {
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .border(frameColor, width: calculateViewportBorderWidth(viewportFrameWidth: geometry.size.width))
                            }
                        }.frame(maxHeight: geometry.size.width)
                        Spacer()
                    }
                }
                .frame(maxWidth: geometry.size.width)
                .background(Color.gray)
                
                        
                VStack {
                    ColorPicker("Select color", selection: $frameColor, supportsOpacity: false)
                    Slider(value: $frameSizeSliderValue, in: 0...10, step: 1) { editing in
                        shouldAskBeforeDismissing = true
                    }
                    Text("\(Int(frameSizeSliderValue))")
                }.padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if shouldAskBeforeDismissing {
                        showingDismissAlert.toggle()
                    } else {
                        dismissView()
                    }
                } label: {
                    Image(systemName: "chevron.backward").imageScale(.large)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                if !isSaving {
                    Button {
                        isSaving = true
                        processAndSaveImage()
                    } label: {
                        Image(systemName: "square.and.arrow.down").imageScale(.large)
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .banner(data: $bannerData, show: $showingSavingResultBanner)
        .alert(isPresented: $showingDismissAlert) {
            // TODO: Adjust texts in this alert
            Alert(title: Text("Discard?"),
                  message: Text("All changes will be lost."),
                  primaryButton: .destructive(Text("Confirm")) {
                    dismissView()
                  },
                  secondaryButton: .default(Text("Cancel"))
            )
        }
    }
    
    private func calculateViewportBorderWidth(viewportFrameWidth: CGFloat) -> CGFloat {
        return frameSizeSliderValue * viewportFrameWidth / 300
    }
    
    private func dismissView() {
        image = nil
        presentationMode.wrappedValue.dismiss()
    }
    
    private func processAndSaveImage() {
        guard let image = image else { return }
        
        // TODO: Add error handling
        DispatchQueue.global(qos: .userInitiated).async {
            let outputImage = processImage(image)
            saveImage(outputImage)
            DispatchQueue.main.async {
                onSavingFinished()
            }
        }
    }
    
    private func onSavingFinished() {
        isSaving = false
        shouldAskBeforeDismissing = false
        showingSavingResultBanner = true
    }
    
    private func processImage(_ image: UIImage) -> UIImage {
        // TODO: Move away from this assumption of max width
        let viewportWidth = UIScreen.main.bounds.width
        let viewportBorderWidth = calculateViewportBorderWidth(viewportFrameWidth: viewportWidth)
        
        let processor = ImageProcessor()
        let outputImage = processor.addBorders(inputImage: image, screenWidth: viewportWidth, screenBorderWidth: viewportBorderWidth, borderColor: frameColor.forcedCgColor())
        return outputImage
    }
    
    private func saveImage(_ image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
    }

}

struct BorderAddingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BorderAddingView(image: .constant(UIImage(named: "nikisz")!))
                .preferredColorScheme(.dark)
        }
    }
}
