//
//  ImageProcessor.swift
//  simpleframe
//
//  Created by Dawid Brzyszcz on 22/09/2021.
//

import SwiftUI

class ImageProcessor {
    
    func addBorders(inputImage: UIImage, screenWidth: CGFloat, screenBorderWidth: CGFloat, borderColor: CGColor) -> UIImage {
        return addBordersAlternative(inputImage: inputImage, borderWidth: calculateRealBorderWidth(inputImage: inputImage, screenWidth: screenWidth, screenBorderWidth: screenBorderWidth), borderColor: borderColor)
    }
    
    func calculateRealBorderWidth(inputImage: UIImage, screenWidth: CGFloat, screenBorderWidth: CGFloat) -> CGFloat {
        let largestSide = max(inputImage.size.width, inputImage.size.height)
        let realWidth = screenBorderWidth * largestSide / screenWidth
        return realWidth
    }
    
    private func addBorders(inputImage: UIImage, borderWidth: CGFloat, borderColor: CGColor) -> UIImage {
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
    
    private func addBordersAlternative(inputImage: UIImage, borderWidth: CGFloat, borderColor: CGColor) -> UIImage {
        let size = inputImage.size
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        inputImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        let borderRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        context?.setStrokeColor(borderColor)
        context?.setLineWidth(borderWidth)
        context?.stroke(borderRect)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
}
