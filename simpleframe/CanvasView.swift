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
    
    @State private var borderPercentage: CGFloat = 0
    
    var MAX_BORDER_SIZE_IN_PERCENTAGE: CGFloat = 10
    var SLIDER_STEP: CGFloat = 1
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
//                    Text("\(geometry.size.width)x\(geometry.size.height)")
                    if let image = image {
//                        let imgMaxFrameSize = getImgMaxFrameSize(canvasSize: geometry.size, image: image)
                        let imgDisplaySize = getImgMaxSize(imageSize: image.size, containerSize: geometry.size)
                        let imgDisplayFrameSize = downscaleAlongLongerDimension(source: imgDisplaySize, scale: getDisplayImgScale())
//                        let borderRectSize = downscaleAlongLongerDimension(source: imgDisplaySize, scale: getRectScale())
                        let borderRectSize = getBorderRectSize(imageSize: imgDisplayFrameSize, borderSizePercentage: borderPercentage)
//                        let _ = print("Frame: \(geometry.size)")
//                        let _ = print("ImgMax: \(imgDisplaySize)")
//                        let _ = print("ImgScale: \(imgDisplayFrameSize)")
                        Rectangle()
                            .fill(.red)
                            .frame(width: borderRectSize.width, height: borderRectSize.height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        Image(uiImage: image)
                            .resizable()
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
                Slider(value: $borderPercentage, in: 0...MAX_BORDER_SIZE_IN_PERCENTAGE, step: SLIDER_STEP)
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
        image = nil
        presentationMode.wrappedValue.dismiss()
    }
    
//    private func getDisplayImgScale() -> CGFloat {
//        return (100.0 - 2 * MAX_BORDER_SIZE_IN_PERCENTAGE) / 100.0
//    }
    
    private func getDisplayImgScale() -> CGFloat {
        return 100.0 / (100.0 + 2 * MAX_BORDER_SIZE_IN_PERCENTAGE)
    }
    
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
    
    private func downscaleAlongLongerDimension(source: CGSize, scale: CGFloat) -> CGSize {
        if (scale == 1.0) {
            return CGSize(width: source.width, height: source.height)
        }
        
        let ix = source.width
        let iy = source.height
        
        let sx, sy: CGFloat
        
        if (source.width > source.height) {
            // scale along X
            sx = scale * ix;
            sy = sx * iy / ix
        } else {
            // scale along Y
            sy = scale * iy
            sx = sy * ix / iy
        }
        return CGSize(width: sx, height: sy)
    }
    
    private func getBorderRectSize(imageSize: CGSize, borderSizePercentage: CGFloat) -> CGSize {
        let ix = imageSize.width
        let iy = imageSize.height
        
        let scaleFactor: CGFloat = (100.0 + 2.0 * borderSizePercentage) / 100.0
        
        let bx, by: CGFloat
        
        if (ix > iy) {
            bx = scaleFactor * ix
            by = iy + bx - ix
        } else {
            by = scaleFactor * iy
            bx = ix + by - iy
        }
        
        return CGSize(width: bx, height: by)
    }
    
}

#Preview {
    CanvasView(image: .constant(UIImage(named: "nikisz")!))
        .preferredColorScheme(.dark)
}
