//
//  ImageProcessor.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 22/09/2021.
//

import SwiftUI

class ImageProcessor {
    
    func addBorders(inputImage: UIImage, screenWidth: CGFloat, screenBorderWidth: CGFloat, borderColor: CGColor) -> UIImage {
        return addBorders(inputImage: inputImage, borderWidth: calculateRealBorderWidth(inputImage: inputImage, screenWidth: screenWidth, screenBorderWidth: screenBorderWidth), borderColor: borderColor)
    }
    
    func addBorders(inputImage: UIImage, borderWidth: CGFloat, borderColor: CGColor) -> UIImage {
        let size = inputImage.size
        let imgRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        //        let borderRect = imgRect.insetBy(dx: 2.0, dy: 2.0)
        let renderer = UIGraphicsImageRenderer(size: size)
        let outputImage = renderer.image { ctx in
            ctx.cgContext.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
            
            ctx.cgContext.draw(inputImage.cgImage!, in: imgRect)
            
            ctx.cgContext.setStrokeColor(borderColor)
            ctx.cgContext.setLineWidth(borderWidth)
            ctx.stroke(imgRect)
        }
        
        return outputImage
    }
    
    func calculateRealBorderWidth(inputImage: UIImage, screenWidth: CGFloat, screenBorderWidth: CGFloat) -> CGFloat {
        let largestSide = max(inputImage.size.width, inputImage.size.height)
        let realWidth = screenBorderWidth * largestSide / screenWidth
        return realWidth
    }
}
