//
//  GameViewController.swift
//  CatNap
//
//  Created by Alejandro on 28/10/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ImageCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let scene = GameScene(fileNamed:"GameScene") {
        if let scene = GameScene.level(6) {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.imageCaptureDelegate = self
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .AllButUpsideDown
//        } else {
//            return .All
//        }
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
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //1
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //2
        picker.dismissViewControllerAnimated(true, completion: {
            //3
            let imageTexture = SKTexture(image: image)
            //4
            let skView = self.view as! SKView
            let gameScene = skView.scene as! GameScene
            //place core image code here
            //5
            gameScene.changePhotoTexture(imageTexture)
        })
    }
}











