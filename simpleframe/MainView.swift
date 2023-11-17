//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 28/09/2021.
//

import SwiftUI

struct MainView: View {
    @State private var isImageSelected = false
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
                Spacer()
                
                Button {
                    showingImagePicker.toggle()
                } label: {
                    VStack {
                        Image(systemName: "plus.viewfinder")
                            .font(.system(size: 64, weight: .thin))
                        Text("Choose image")
                    }
                }.sheet(isPresented: $showingImagePicker) {
                    if (self.image != nil) {
                        isImageSelected = true
                    }
                } content: {
                    ImagePicker(image: $image)
                }
                
                Spacer()
                
                NavigationLink(isActive: $isImageSelected) {
                    CanvasView(image: $image)
                } label: {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
