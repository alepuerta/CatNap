//
//  OldTVNode.swift
//  CatNap
//
//  Created by Alejandro on 14/11/15.
//  Copyright © 2015 Alejandro. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class OldTVNode: SKSpriteNode {
    let player: AVPlayer
    let videoNode: SKVideoNode
    
    var notificationObserver: AnyObject?
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSConding not supported")
    }
    
    init(frame: CGRect) {
        // 1
//        let filePath = NSBundle.mainBundle().pathForResource("BookTrailer", ofType: "m4v")
        let filePath = NSBundle.mainBundle().pathForResource("loop", ofType: "mov")
        let fileURL = NSURL(fileURLWithPath: filePath!)
        // 2
        player = AVPlayer(URL: fileURL)
        videoNode = SKVideoNode(AVPlayer: player)
        // 3
        let cropNode = SKCropNode()
        let maskNode = SKSpriteNode(imageNamed: "tv-mask")
        cropNode.maskNode = maskNode
        cropNode.addChild(videoNode)
        // 4 
        let rect = CGRectInset(frame, frame.size.width * 0.15, frame.size.height * 0.24)
        videoNode.size = rect.size
        videoNode.position = CGPoint(x: -frame.size.width * 0.1, y: -frame.size.height * 0.06)
        // 5
        let texture = SKTexture(imageNamed: "tv")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        // 6
        self.name = "TVNode"
        self.addChild(cropNode)
        // 7
        self.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        self.size = frame.size
        // 8
        player.volume = 0.0
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        let notificationName = AVPlayerItemDidPlayToEndTimeNotification
        
        player.actionAtItemEnd = .None
        notificationObserver = notificationCenter.addObserverForName(
            notificationName,
            object: nil, queue: mainQueue) { _ in
                self.player.seekToTime(kCMTimeZero)
        }
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGRectInset(frame, 2, 2).size)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Block
        self.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Cat | PhysicsCategory.Edge
        
        videoNode.play()
    }
    
    deinit {
        if let deleteNotification: AnyObject = notificationObserver {
            NSNotificationCenter.defaultCenter().removeObserver(deleteNotification)
        }
    }
}
