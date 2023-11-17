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
    @State private var borderColor: Color = Color.black
    
    var MAX_BORDER_SIZE_IN_PERCENTAGE: CGFloat = 10
    var SLIDER_STEP: CGFloat = 1
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    if let image = image {
                        let imgDisplaySize = getImgSize(imageSize: image.size, containerSize: geometry.size)
                        let borderRectSize = getBorderRectSize(imageSize: imgDisplaySize)
                        Rectangle()
                            .fill(borderColor)
                            .frame(width: borderRectSize.width, height: borderRectSize.height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: imgDisplaySize.width, height: imgDisplaySize.height)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
            }
            .background(Color.green)
            VStack {
                ColorPicker("Select color", selection: $borderColor, supportsOpacity: false)
                Slider(value: $borderPercentage, in: 0...MAX_BORDER_SIZE_IN_PERCENTAGE, step: SLIDER_STEP)
            }
            .padding()
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
    
    private func getImgSize(imageSize: CGSize, containerSize: CGSize) -> CGSize {
        // real image dimensions
        let rx = imageSize.width
        let ry = imageSize.height
        
        // container size dimensions (available screen size)
        let cx = containerSize.width
        let cy = containerSize.height
        
        let cyx = cy / cx
        let ryx = ry / rx
        
        // max image dimensions
        let ix, iy: CGFloat
        
        // scaled image dimensions
        let fx, fy: CGFloat
        
        let downscaleFactor = 100.0 / (100.0 + 2 * MAX_BORDER_SIZE_IN_PERCENTAGE)
        let upscaleFactor = (100.0 + 2 * MAX_BORDER_SIZE_IN_PERCENTAGE) / 100.0
        
        if (cyx < ryx) {
            // image is restricted vertically
            ix = (cy * rx) / ry
            iy = cy
            
            if (ix > iy) {
                // image is horizontal
                // TODO: Double check current eq (taken from horizontal restriction + vertical image)
                fy = iy / (1 + ix * (upscaleFactor - 1) / iy)
            } else {
                // image is vertical
                fy = iy * downscaleFactor
            }
            fx = ix * fy / iy
            
        } else {
            // image is restricted horizontally
            ix = cx
            iy = (cx * ry) / rx
            
            if (ix > iy) {
                // image is horizontal
                fx = ix * downscaleFactor
            } else {
                // image is vertical
                fx = ix / (1 + iy * (upscaleFactor - 1) / ix)
                
            }
            fy = iy * fx / ix
        }
        return CGSize(width: fx, height: fy)
    }
    
    private func getBorderRectSize(imageSize: CGSize) -> CGSize {
        let ix = imageSize.width
        let iy = imageSize.height
        
        let scaleFactor: CGFloat = (100.0 + 2.0 * borderPercentage) / 100.0
        
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
