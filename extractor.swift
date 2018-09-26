//
//  extractor.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/20/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class extractor: SKNode {
    var extractorSprite:SKSpriteNode!
    var extractorAtlas:SKTextureAtlas!
    var extractorAnimation:Array<SKTexture> = []
    var particleEffect:SKEmitterNode!
    
    var combatStats:unitCombatStats!
    var resourceProduction:Int = 1
    var resourceCost:Int = 4
    //var animation:SKAction!
    
    init(extractorAtlas: SKTextureAtlas){
        super.init()
        self.createExtractor(Atlas: extractorAtlas)
        self.combatStats = unitCombatStats()
        self.combatStats.setForExtractor()
    }
    
    private func createExtractor(Atlas: SKTextureAtlas){
        self.extractorAtlas = Atlas
        for name in Atlas.textureNames {
            self.extractorAnimation.append(SKTexture(imageNamed: name))
        }
        
        self.extractorSprite = SKSpriteNode(imageNamed: Atlas.textureNames[0])
        self.extractorSprite.size = CGSize(width: 100, height: 100)
        self.extractorSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(self.extractorSprite)

        self.particleEffect = SKEmitterNode(fileNamed: "ExtractorSmoke.sks")
        if self.extractorAtlas.textureNames[0] == "ExtractorOne-2.png" {
            self.extractorSprite.size = CGSize(width: 100, height: 100)
            self.extractorSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            self.particleEffect.particleSpeed = 0.5
            self.particleEffect.particleSize = CGSize(width: 20, height: 20)
            self.particleEffect.particleLifetime = 2
            self.particleEffect.particleScale = 1.25
            self.particleEffect.particlePositionRange = CGVector(dx: 10, dy: 0)
            self.particleEffect.particleBirthRate = 8
            self.particleEffect.position = CGPoint(x: -5, y: 25)
        }
        if self.extractorAtlas.textureNames[0] == "J_extractor-1.png"{
            self.extractorSprite.size = CGSize(width: 140, height: 140)
            self.extractorSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            self.particleEffect.particleSpeed = 0.5
            self.particleEffect.particleSize = CGSize(width: 20, height: 20)
            self.particleEffect.particleLifetime = 2
            self.particleEffect.particleScale = 1.25
            self.particleEffect.particlePositionRange = CGVector(dx: 10, dy: 0)
            self.particleEffect.particleBirthRate = 8
            self.particleEffect.position = CGPoint(x: 0, y: 30)
        }
        if self.extractorAtlas.textureNames[0] == "R_extractor-1.png" {
            self.extractorSprite.size = CGSize(width: 120, height: 120)
            self.extractorSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            self.particleEffect.particleSpeed = 0.5
            self.particleEffect.particleSize = CGSize(width: 20, height: 20)
            self.particleEffect.particleLifetime = 2
            self.particleEffect.particleScale = 1.25
            self.particleEffect.particlePositionRange = CGVector(dx: 8, dy: 0)
            self.particleEffect.particleBirthRate = 8
            self.particleEffect.position = CGPoint(x: 16, y: 40)
        }
        self.extractorSprite.addChild(self.particleEffect)
    }
    
    func modifyColor(color: SKColor, blendfactor: CGFloat, blendMode: SKBlendMode){
        self.extractorSprite.blendMode = blendMode
        self.extractorSprite.colorBlendFactor = blendfactor
        self.extractorSprite.color = color
    }
    func modifySpawnPosition(position: CGPoint){
        self.extractorSprite.position = position
    }
    func modifyExtractorSize(newSize: CGSize){
        self.extractorSprite.size = newSize
    }
    
    func getNodeCopy(andNameIt: String) -> extractor {
        let copiedNode = extractor(extractorAtlas: self.extractorAtlas)
        copiedNode.name = andNameIt
        copiedNode.extractorSprite.size = self.extractorSprite.size
        copiedNode.isHidden = false
        return copiedNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.extractorSprite = aDecoder.decodeObject(forKey: "extractorSprite") as? SKSpriteNode
        self.extractorAnimation = (aDecoder.decodeObject(forKey: "extractorAnimation") as? Array<SKTexture>)!
        self.extractorAtlas = aDecoder.decodeObject(forKey: "extractorAtlas") as? SKTextureAtlas
        self.particleEffect = aDecoder.decodeObject(forKey: "particleEffect") as? SKEmitterNode!
        
        self.combatStats = aDecoder.decodeObject(forKey: "combatStats") as? unitCombatStats!
        self.resourceProduction = aDecoder.decodeInteger(forKey: "production")
        self.resourceCost = aDecoder.decodeInteger(forKey: "cost")
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.extractorSprite, forKey: "extractorSprite")
        aCoder.encode(self.extractorAnimation, forKey: "extractorAnimation")
        aCoder.encode(self.extractorAtlas, forKey: "extractorAtlas")
        aCoder.encode(self.particleEffect, forKey: "particleEffect")
        
        aCoder.encode(self.combatStats, forKey: "combatStats")
        aCoder.encode(self.resourceProduction, forKey: "production")
        aCoder.encode(self.resourceCost, forKey: "cost")
    }
}
