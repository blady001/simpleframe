//
//  ImageSavingView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 22/09/2021.
//

import SwiftUI

struct ImageSavingView: View {
    @Binding var isPresented: Bool
    @Binding var isSaving: Bool
    
    var body: some View {
        VStack {
            if isSaving {
                ProgressView("Saving image...")
            } else {
                Text("Image saved to Photos!")
                Button("Press to dismiss") {
                    isPresented = false
                }
            }
        }
        .padding()
    }
}


//struct ImageSavingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSavingView(isPresented: true, isSavingFinished: <#T##Binding<Bool>#>)
//    }
//}
