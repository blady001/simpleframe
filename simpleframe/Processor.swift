//
//  Processor.swift
//  simpleframe
//
//  Created by Dawid on 17/11/2023.
//

import SwiftUI

func addBorders(to image: UIImage, color: CGColor, size: CGFloat) -> UIImage {
    let longerEdge = max(image.size.width, image.size.height)
    let borderWidth = longerEdge * size / 100.0
    let outputSize = CGSize(width: image.size.width + 2.0 * borderWidth, height: image.size.height + 2.0 * borderWidth)
    let background = CGRect(origin: CGPoint(x: 0, y: 0), size: outputSize)
    
    let renderer = UIGraphicsImageRenderer(size: outputSize)
    return renderer.image(actions: { (context) in
        UIColor(cgColor: color).setFill()
        context.fill(background)
        image.draw(at: CGPoint(x: borderWidth, y: borderWidth))
    })
}
