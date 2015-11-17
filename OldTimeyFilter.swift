//
//  OldTimeyFilter.swift
//  CatNap
//
//  Created by Alejandro on 16/11/15.
//  Copyright © 2015 Alejandro. All rights reserved.
//

import Foundation
import CoreImage

class OldTimeyFilter: CIFilter {
    var inputImage: CIImage?
    
    override var outputImage:CIImage! {
        let time = CFAbsoluteTimeGetCurrent()
        
        let first = sin(time / 15.0) * 100.0
        let second = sin(time / 2.0) * 25.0
        
        let v1: [Float] = [Float(first), 1.5]
        let v2: [Float] = [Float(second), 1.5]
        
        let randVal1 = noise2(UnsafeMutablePointer(v1))
        let randVal2 = noise2(UnsafeMutablePointer(v2))
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(0.0, forKey: "inputSaturation")
        colorControls?.setValue(randVal2 * 0.2, forKey: "inputBrightness")
        
        let vignette = CIFilter(name: "CIVignette")
        vignette?.setValue(0.2 + randVal2, forKey: "inputRadius")
        vignette?.setValue(randVal2 * 0.2 + 0.8, forKey: "inputIntensity")
        
        // 1 
        var transform = CGAffineTransformMakeTranslation(CGFloat(0.0), CGFloat(randVal1 * 45.0))
        // 2
        colorControls?.setValue(inputImage, forKey: kCIInputImageKey)
        // 3
        vignette?.setValue(colorControls?.outputImage, forKey: kCIInputImageKey)
        return vignette!.outputImage!.imageByApplyingTransform(transform)
    }
}

