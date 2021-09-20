//
//  ImagePickerTestView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 20/09/2021.
//

import SwiftUI

struct ImagePickerTestView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    
    var body: some View {
        if let image = image {
            image.resizable()
                .scaledToFit()
        } else {
            Button("Select image") {
                showingImagePicker.toggle()
            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage =  inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

struct ImagePickerTestView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerTestView()
    }
}
