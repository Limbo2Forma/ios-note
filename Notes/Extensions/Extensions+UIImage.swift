//
//  Extensions+UIImage.swift
//  Notes
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resized(width: CGFloat) -> UIImage? {
        
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

