//
//  MainView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 28/09/2021.
//

import SwiftUI

struct MainView: View {
    @State private var imageSelected = false
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
//                    .background(Rectangle().fill(Color.red))
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
                    imageSelected.toggle()
                } content: {
                    ImagePicker(image: $image)
                }
                
//                .background(Rectangle().fill(Color.green))
                
                Spacer()
                
                NavigationLink(isActive: $imageSelected) {
//                    BorderAddingView(image: $image)
                    CanvasView(image: $image)
                } label: {
                    EmptyView()
                }
            }
//            .background(Color.yellow)
            .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
