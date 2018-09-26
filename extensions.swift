//
//  protocols.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/20/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension Int
{
    static func random(range: ClosedRange<Int>) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

class SpriteButton: SKSpriteNode {
    var label:SKLabelNode!
    init() {
        let buttonTexture = SKTexture(imageNamed: "Button_BG_final")
        super.init(texture: buttonTexture, color: SKColor.clear, size: CGSize(width: 100, height: 30))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        label = SKLabelNode(text: "Default")
        label.position = CGPoint(x: 0, y: -7)
        label.fontColor = SKColor.white
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        self.name = "Default"
        self.addChild(label)
    }
    convenience init(size: CGSize){
        self.init()
        self.size = size
    }
    
    func changeButtonSize(to size: CGSize){
        self.size = size
    }
    func changeButtonText(to: String){
        self.label.text = to
        self.name = to
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.label = aDecoder.decodeObject(forKey: "label") as? SKLabelNode!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.label, forKey: "label")
    }
}

class CombatLabel: SKSpriteNode {
    var hitpoints:SKLabelNode!
    var attackValue:SKLabelNode!
    var defenseValue:SKLabelNode!
    
    init(){
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: 50, height: 100))
        self.isUserInteractionEnabled = false
        self.defenseValue = SKLabelNode()
        self.defenseValue.fontName = "AvenirNext-Bold"
        self.defenseValue.fontSize = 10
        self.defenseValue.fontColor = SKColor.white
        self.defenseValue.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(self.defenseValue)
        
        self.hitpoints = SKLabelNode()
        self.hitpoints.fontName = "AvenirNext-Bold"
        self.hitpoints.fontSize = 10
        self.hitpoints.fontColor = SKColor.white
        self.hitpoints.position = CGPoint(x: self.defenseValue.position.x, y: self.defenseValue.position.y + 30)
        self.addChild(self.hitpoints)
        
        self.attackValue = SKLabelNode()
        self.attackValue.fontName = "AvenirNext-Bold"
        self.attackValue.fontSize = 10
        self.attackValue.fontColor = SKColor.white
        self.attackValue.position = CGPoint(x: self.defenseValue.position.x, y: self.defenseValue.position.y - 30)
        self.addChild(self.attackValue)
    }
    
    func setLabel(for information: unitCombatStats){
        self.hitpoints.text = "HitPoints: \(information.currentHitPoints!) / \(information.hitPoints!)"
        self.attackValue.text = "Attack-Power: \(information.currentAttackPower!)"
        self.defenseValue.text = "Defence-Power: \(information.currentDefensePower!)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hitpoints = aDecoder.decodeObject(forKey: "hitpoints") as? SKLabelNode!
        self.attackValue = aDecoder.decodeObject(forKey: "attack") as! SKLabelNode!
        self.defenseValue = aDecoder.decodeObject(forKey: "defense") as! SKLabelNode!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.hitpoints, forKey: "hitpoints")
        aCoder.encode(self.attackValue, forKey: "attack")
        aCoder.encode(self.defenseValue, forKey: "defense")
    }
}














