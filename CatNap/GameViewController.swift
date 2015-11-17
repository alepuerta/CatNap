//
//  GameViewController.swift
//  CatNap
//
//  Created by Alejandro on 28/10/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

import UIKit
import SpriteKit

//extension SKNode {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
////            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
//            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//            
//            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
//            archiver.finishDecoding()
//            return scene
//        } else {
//            return nil
//        }
//    }
//}

class GameViewController: UIViewController, ImageCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    override func viewDidLoad() {       
        super.viewDidLoad()
        
        if let scene = GameScene.level(1) {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsPhysics = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            scene.imageCaptureDelegate = self
            
//            let ciFilters = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
//            for filterName in ciFilters {
//                print(ciFilters.count)
//                print(filterName)
//                let filter = CIFilter(name: filterName as String)
//                print(filter!.attributes)
//            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func requestImagePicker() {
        let imagePickerControlller = UIImagePickerController()
        imagePickerControlller.delegate = self
        presentViewController(
            imagePickerControlller, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: {
            let imageTexture = SKTexture(image: image)
            let skView = self.view as! SKView
            let gameScene = skView.scene as! GameScene
            //place core image code here
            gameScene.changePhotoTexture(imageTexture)
//            let sepia = CIFilter(name: "CISepiaTone")
//            sepia!.setValue(0.8, forKey: "inputIntensity")
//            let filteredTexture = imageTexture.textureByApplyingCIFilter(sepia!)
//            gameScene.changePhotoTexture(filteredTexture)
        })
    }
    
}
