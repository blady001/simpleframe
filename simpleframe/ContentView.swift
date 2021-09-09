//
//  ContentView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 08/09/2021.
//

import SwiftUI

struct ContentView: View {
    @State var borderWidth: CGFloat = 50.0
    @State var image: UIImage = UIImage(named: "nikisz")!
    
    var imageView: some View {
//        Image("nikisz")
//            .resizable()
////                .padding()
////                .padding(borderWidth)
//            .scaledToFill()
////                .scaledToFit()
////                    .frame(width: 200, height: 200)
//            .border(Color.pink, width: borderWidth)
        GeometryReader { geometry in
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//                .padding()
//                .frame(width: geometry.size.width, height: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
//                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
            }
        }
    }
    
    var borderSliderView: some View {
        VStack {
            Slider(value: $borderWidth, in: 1...50)
            Text("Choose border width")
        }
    }
    
    var body: some View {
        VStack {
            imageView
            Button("Print size") {
                print("Image size: \(self.image.size.width)x\(self.image.size.height)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
