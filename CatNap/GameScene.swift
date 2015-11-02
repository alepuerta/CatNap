//
//  GameScene.swift
//  CatNap
//
//  Created by Alejandro on 28/10/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let None:    UInt32 = 0
        static let Cat:     UInt32 = 0b1        // 1
        static let Block:   UInt32 = 0b10       // 2
        static let Bed:     UInt32 = 0b100      // 4
        static let Edge:    UInt32 = 0b1000     // 8
        static let Label:   UInt32 = 0b10000    // 16
    }

    var bedNode: SKSpriteNode!
    var catNode: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.height, height: size.height - playableMargin*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        bedNode = childNodeWithName("bed") as! SKSpriteNode
        catNode = childNodeWithName("cat") as! SKSpriteNode
        
//        bedNode.setScale(1.5)
//        catNode.setScale(1.5)
        
        let bedBodySize = CGSize(width: 40, height: 30)
        bedNode.physicsBody = SKPhysicsBody(rectangleOfSize: bedBodySize)
        bedNode.physicsBody!.dynamic = false
        
        let catBodyTexture = SKTexture(imageNamed: "cat_body")
        catNode.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catNode.size)
        
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        bedNode.physicsBody!.categoryBitMask = PhysicsCategory.Bed
        bedNode.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        catNode.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        catNode.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
        catNode.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
    }
    
    func sceneTouched(location: CGPoint) {
        // 1
        let targetNode = self.nodeAtPoint(location)
        // 2
        if targetNode.physicsBody == nil {
            return
        }
        // 3
        if targetNode.physicsBody!.categoryBitMask == PhysicsCategory.Block {
            targetNode.removeFromParent()
            // 4
            runAction(SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false))
            return
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch: UITouch = touches.first {
            sceneTouched(touch.locationInNode(self))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("SUCCESS")
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("FAIL")
        }
    }
    
    func inGameMessage(text: String) {
        // 1
        let label: SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
        label.text = text
        label.fontSize = 128.0
        label.color = SKColor.whiteColor()
        // 2
        label.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        label.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        label.physicsBody!.collisionBitMask = PhysicsCategory.Edge
        label.physicsBody!.categoryBitMask = PhysicsCategory.Label
        label.physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        label.physicsBody!.restitution = 0.7
        // 3
        addChild(label)
        // 4
        runAction(SKAction.sequence([SKAction.waitForDuration(3), SKAction.removeFromParent()]))
    }
    
    func newGame() {
        view!.presentScene(GameScene(fileNamed: "GameScene"))
    }
}





