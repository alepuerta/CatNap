//
//  CustomTransitionFilter.swift
//  CatNap
//
//  Created by Alejandro on 17/11/15.
//  Copyright © 2015 Alejandro. All rights reserved.
//

import Foundation
import CoreImage

class CustomTransitionFilter: CIFilter {
    var inputImage: CIImage?
    var inputTargetImage: CIImage?
    var inputTime: NSNumber?
 
    override var outputImage:CIImage! {
        // 1
        if inputTime == nil {
            return nil
        }
        if inputTargetImage == nil {
            return nil
        }
        if inputImage == nil {
            return nil
        }
        // 2
        let color = CIFilter(name: "CIConstantColorGenerator")
        color?.setValue(CIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(inputTime!.floatValue)), forKey: "inputColor")
        // 3
        let blendWithMask = CIFilter(name: "CIBlendWithAlphaMask")
        blendWithMask?.setValue(color?.outputImage, forKey: "inputMaskImage")
        blendWithMask?.setValue(inputImage, forKey: "inputBackgroundImage")
        blendWithMask?.setValue(inputTargetImage, forKey: "inputImage")
        // 4
        let transform = CGAffineTransformMakeRotation(CGFloat(inputTime!) * 3.14 * 4.0)
        // 5
        return blendWithMask?.outputImage?.imageByApplyingTransform(transform)
    }
}
