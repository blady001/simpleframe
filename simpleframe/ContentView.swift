//
//  ContentView.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 08/09/2021.
//

import SwiftUI

struct ContentView: View {
    private let imgPadding: CGFloat = 20
    @State var borderWidth: CGFloat = 20
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
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(
                        width: (image.size.width / image.size.height) * geometry.size.width - 2*imgPadding + borderWidth,
                        height: geometry.size.width - 2*imgPadding + borderWidth,
                        alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Image(uiImage: image)
                    .resizable()
                    .padding(imgPadding)
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                
            }
        }
    }
    
    var body: some View {
        VStack {
            imageView
            Slider(value: $borderWidth, in: 0...40)
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
