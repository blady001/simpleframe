//
//  Canvas.swift
//  simpleframe
//
//  Created by Dawid on 29/10/2023.
//

import SwiftUI

struct CanvasView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var image: UIImage?
    
    @State private var sliderValue: CGFloat = 0
    
    var MAX_BORDER_SIZE_IN_PERCENTAGE: CGFloat = 10
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
//                    Text("\(geometry.size.width)x\(geometry.size.height)")
                    if let image = image {
//                        let imgMaxFrameSize = getImgMaxFrameSize(canvasSize: geometry.size, image: image)
                        let imgDisplaySize = getImgMaxSize(imageSize: image.size, containerSize: geometry.size)
                        let imgDisplayFrameSize = imgDisplaySize
                        //                        let imgDisplayFrameSize = getImgFrameScaled(imageMaxSize: imgMaxFrameSize)
//                        let rectSize = getRectSize(imageSize: imageSize)
//                        Rectangle()
//                            .fill(.red)
//                            .frame(width: rectSize.width, height: rectSize.height)
//                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        Image(uiImage: image)
                            .resizable()
//                            .scaledToFit()
                            .frame(width: imgDisplayFrameSize.width, height: imgDisplayFrameSize.height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    //                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    //                            .frame(width: geometry.size.width - 50)
//                            .background(Color.blue)
                    }
                }
            }
            .background(Color.orange)
            VStack {
                Slider(value: $sliderValue, in: 0...MAX_BORDER_SIZE_IN_PERCENTAGE, step: 1)
            }
            .background(Color.purple)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
    //                if shouldAskBeforeDismissing {
    //                    showingDismissAlert.toggle()
    //                } else {
                        dismissView()
    //                }
                } label: {
                    Image(systemName: "chevron.backward").imageScale(.large)
                }
            }
        }
    }
    
    private func dismissView() {
//        image = nil
        presentationMode.wrappedValue.dismiss()
    }
    
//    private func getImgMaxFrameSize(canvasSize: CGSize, image: UIImage) -> CGSize {
//        
//        let d: CGFloat = 1 + 2.0 * (MAX_BORDER_SIZE_IN_PERCENTAGE / 100.0)
//        
//        // real image dimensions
//        let rx = image.size.width
//        let ry = image.size.height
//        
//        // canvas screen dimensions
//        let cx = canvasSize.width
//        let cy = canvasSize.height
//        
//        let cyx = cy / cx
//        let ryx = ry / rx
//        
//        let ix, iy: CGFloat
//        
//        // TODO: currently "d" is calculated not per greatest side, but per alignment either to top or to side
//        // This should be changed, so that the image border is restricted by its longer side
//        if (cyx < ryx) {
//            // image is horizontal
//            ix = (cy * rx) / (d * ry)
//            iy = cy / d
//        } else {
//            // image is vertical
//            ix = cx / d
//            iy = (cx * ry) / (d * rx)
//        }
//        return CGSize(width: ix, height: iy)
//    }
    
    private func getImgMaxSize(imageSize: CGSize, containerSize: CGSize) -> CGSize {
        // real image dimensions
        let rx = imageSize.width
        let ry = imageSize.height
        
        // container size dimensions (available screen size)
        let cx = containerSize.width
        let cy = containerSize.height
        
        let cyx = cy / cx
        let ryx = ry / rx
        
        // scaled image dimensions
        let ix, iy: CGFloat
        
        if (cyx < ryx) {
            // image is restricted vertically
            ix = (cy * rx) / ry
            iy = cy
        } else {
            // image is restricted horizontally
            ix = cx
            iy = (cx * ry) / rx
        }
        return CGSize(width: ix, height: iy)
    }
    
//    private func getImgMaxFrameSize(canvasSize: CGSize, image: UIImage) -> CGSize {
//        // real image dimensions
//        let rx = image.size.width
//        let ry = image.size.height
//        
//        // canvas screen dimensions
//        let cx = canvasSize.width
//        let cy = canvasSize.height
//        
//        let cyx = cy / cx
//        let ryx = ry / rx
//        
//        let ix, iy: CGFloat
//        
//        // TODO: currently "d" is calculated not per greatest side, but per alignment either to top or to side
//        // This should be changed, so that the image border is restricted by its longer side
//        if (cyx < ryx) {
//            // image is horizontal
//            ix = (cy * rx) / ry
//            iy = cy
//        } else {
//            // image is vertical
//            ix = cx
//            iy = (cx * ry) / rx
//        }
//        return CGSize(width: ix, height: iy)
//    }
    
    private func getImgFrameScaled(imageMaxSize: CGSize) -> CGSize {
        let ix = imageMaxSize.width
        let iy = imageMaxSize.height
        
        let sx, sy: CGFloat
        
        let d: CGFloat = (100 + 2 * MAX_BORDER_SIZE_IN_PERCENTAGE) / 100
        
        if (ix > iy) {
            sx = ix / d
            sy = sx * iy / ix
        } else {
            sy = iy / d
            sx = ix * sy / iy
        }
        
        return CGSize(width: sx, height: sy)
    }
    
    private func getRectSize(imageSize: CGSize) -> CGSize {
        let d: CGFloat = sliderValue / 100.0
        
        let ix = imageSize.width
        let iy = imageSize.height
        
        let b: CGFloat
        
        if (iy > ix) {
            // image is horizontal
            b = d * iy
        } else {
            // image is vertical
            b = d * ix
        }
        
        return CGSize(width: ix + 2 * b, height: iy + 2 * b)
    }
}

#Preview {
    CanvasView(image: .constant(UIImage(named: "nikisz")!))
        .preferredColorScheme(.dark)
}
