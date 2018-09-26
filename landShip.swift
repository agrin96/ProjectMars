//
//  landShip.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/20/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class landship: SKNode {
    var landShipSprite:SKSpriteNode!
    var landShipAtlas:SKTextureAtlas!
    var landShipAnimation:Array<SKTexture> = []
    var particleEffect:SKEmitterNode!
    
    var attackState:(origin: Province, destination: Province, attacking: Bool, attacked: Bool)?
    var hasMoved:Bool = false
    var combatStats:unitCombatStats!
    
    init(landShipAtlas: SKTextureAtlas){
        super.init()
        self.createLandShip(Atlas: landShipAtlas)
        self.combatStats = unitCombatStats()
        self.combatStats.setForLandShip()
    }
    
    private func createLandShip(Atlas: SKTextureAtlas){
        self.landShipAtlas = Atlas
        for name in Atlas.textureNames {
            self.landShipAnimation.append(SKTexture(imageNamed: name))
        }
        
        self.landShipSprite = SKSpriteNode(imageNamed: Atlas.textureNames[0])
        if Atlas.textureNames[0] == "RoverFactory-1.png"{
            self.landShipSprite.size = CGSize(width: 80, height: 80)
            self.landShipSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        if Atlas.textureNames[0] == "J_landship-2.png" {
            self.landShipSprite.size = CGSize(width: 90, height: 90)
            self.landShipSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        if Atlas.textureNames[0] == "R_landship-2.png" {
            self.landShipSprite.size = CGSize(width: 100, height: 100)
            self.landShipSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        self.addChild(self.landShipSprite)
    }
    func addParticleEffect(){
        if self.landShipAtlas.textureNames[0] == "RoverFactory-1.png"{
            self.particleEffect = SKEmitterNode(fileNamed: "ExtractorSmoke.sks")
            self.particleEffect.particleSpeed = 0.5
            self.particleEffect.particleSize = CGSize(width: 10, height: 10)
            self.particleEffect.particleLifetime = 2
            self.particleEffect.particleScale = 1.25
            self.particleEffect.particlePositionRange = CGVector(dx: 0, dy: 0)
            self.particleEffect.particleBirthRate = 8
            self.particleEffect.position = CGPoint(x: 6, y: 38)
        }
        if self.landShipAtlas.textureNames[0] == "J_landship-2.png"{
            self.particleEffect = SKEmitterNode(fileNamed: "Hover.sks")
            self.particleEffect.particleAlpha = 0.3
            self.particleEffect.particleSpeed = -0.10
            self.particleEffect.particleSize = CGSize(width: 30, height: 30)
            self.particleEffect.particleLifetime = 0.5
            self.particleEffect.particlePositionRange = CGVector(dx: 20, dy: 0)
            self.particleEffect.particleBirthRate = 12
            self.particleEffect.position = CGPoint(x: 0, y: -35)
        }
        if self.landShipAtlas.textureNames[0] == "R_landship-2.png" {
            self.particleEffect = SKEmitterNode(fileNamed: "ExtractorSmoke.sks")
            self.particleEffect.particleSpeed = 0.5
            self.particleEffect.particleSize = CGSize(width: 10, height: 10)
            self.particleEffect.particleLifetime = 2
            self.particleEffect.particleScale = 1.25
            self.particleEffect.particlePositionRange = CGVector(dx: 0, dy: 0)
            self.particleEffect.particleBirthRate = 8
            self.particleEffect.position = CGPoint(x: 30, y: 32)
        }
        self.landShipSprite.addChild(self.particleEffect)
    }
    
    func modifyColor(color: SKColor, blendfactor: CGFloat, blendMode: SKBlendMode){
        self.landShipSprite.blendMode = blendMode
        self.landShipSprite.colorBlendFactor = blendfactor
        self.landShipSprite.color = color
    }
    func modifySpawnPosition(position: CGPoint){
        self.landShipSprite.position = position
    }
    func modifyLandShipSize(newSize: CGSize){
        self.landShipSprite.size = newSize
    }
    
    func getNodeCopy(andNameIt: String) -> landship {
        let copiedNode = landship(landShipAtlas: self.landShipAtlas)
        copiedNode.name = andNameIt
        return copiedNode
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.landShipSprite = aDecoder.decodeObject(forKey: "landShipSprite") as? SKSpriteNode
        self.landShipAnimation = (aDecoder.decodeObject(forKey: "landShipAnimation") as? Array<SKTexture>)!
        self.landShipAtlas = aDecoder.decodeObject(forKey: "landShipAtlas") as? SKTextureAtlas
        //self.particleEffect = aDecoder.decodeObject(forKey: "particleEffect") as? SKEmitterNode!
        
        self.attackState = aDecoder.decodeObject(forKey: "attackState") as? (origin: Province, destination: Province, attacking: Bool, attacked: Bool)
        self.hasMoved = aDecoder.decodeBool(forKey: "hasMoved")
        self.combatStats = aDecoder.decodeObject(forKey: "combatStats") as? unitCombatStats!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.landShipSprite, forKey: "landShipSprite")
        aCoder.encode(self.landShipAnimation, forKey: "landShipAnimation")
        aCoder.encode(self.landShipAtlas, forKey: "landShipAtlas")
        aCoder.encode(self.particleEffect, forKey: "particleEffect")
        if self.attackState != nil {
            let saveAttack:(origin: Province, destination: Province, attacking: Bool, attacked: Bool) = self.attackState!
            aCoder.encode(saveAttack, forKey: "attackState")
        }
        aCoder.encode(self.hasMoved, forKey: "hasMoved")
        aCoder.encode(self.combatStats, forKey: "combatStats")
    }
}
