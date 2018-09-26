//
//  movementUI.swift
//  project-mars
//
//  Created by Aleksandr Grin on 2/3/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class movementUI: SKNode {
    var retreatButton:SpriteButton!
    var confirmAttackButton:SpriteButton!
    var resolveAll:SpriteButton!
    
    var attackerInformation:CombatLabel!
    var defenderInformation:CombatLabel!
    
    var currentUnitStats:CombatLabel!
    var attackerRoll:SpriteButton!
    var defenderRoll:SpriteButton!
    
    init(size: CGSize){
        super.init()
        self.createAttackConfirm()
        self.createRetreatButton()
        self.createCombatInformation(size: size)
        self.createCurrentInfo()
        self.createDiceRollDisplay()
        self.createAttackAll()
        self.clearAttackButtons()
    }
    func clearAttackButtons(){
        self.retreatButton.isHidden = true
        self.retreatButton.isUserInteractionEnabled = false
        self.confirmAttackButton.isHidden = true
        self.confirmAttackButton.isUserInteractionEnabled = false
        self.resolveAll.isHidden = true
        self.resolveAll.isUserInteractionEnabled = false
    }
    func setAttackButtons(){
        self.retreatButton.isHidden = false
        self.retreatButton.isUserInteractionEnabled = true
        self.confirmAttackButton.isHidden = false
        self.confirmAttackButton.isUserInteractionEnabled = true
        self.resolveAll.isHidden = false
        self.resolveAll.isUserInteractionEnabled = true
    }
    private func createRetreatButton(){
        self.retreatButton = SpriteButton()
        self.retreatButton.changeButtonSize(to: CGSize(width: 60, height: 40))
        self.retreatButton.changeButtonText(to: "Retreat")
        self.retreatButton.zPosition = 5
    }
    private func createAttackConfirm(){
        self.confirmAttackButton = SpriteButton()
        self.confirmAttackButton.changeButtonSize(to: CGSize(width: 60, height: 40))
        self.confirmAttackButton.changeButtonText(to: "Attack")
        self.confirmAttackButton.zPosition = 5
    }
    private func createAttackAll(){
        self.resolveAll = SpriteButton()
        self.resolveAll.changeButtonSize(to: CGSize(width: 60, height: 40))
        self.resolveAll.changeButtonText(to: "Resolve")
        self.resolveAll.zPosition = 5
    }
    private func createCurrentInfo(){
        self.currentUnitStats = CombatLabel()
        self.currentUnitStats.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.currentUnitStats.zPosition = 5
        self.currentUnitStats.position = CGPoint(x: (0 - (self.currentUnitStats.size.width / 2)), y: 0)
        self.currentUnitStats.isUserInteractionEnabled = false
        self.currentUnitStats.isHidden = true
    }
    
    private func createCombatInformation(size: CGSize){
        self.attackerInformation = CombatLabel()
        self.attackerInformation.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.attackerInformation.zPosition = 5
        self.attackerInformation.position = CGPoint(x: -(size.width / 2) + 30, y: 0)
        
        self.defenderInformation = CombatLabel()
        self.defenderInformation.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        self.defenderInformation.zPosition = 5
        self.defenderInformation.position = CGPoint(x: ((size.width / 2) - 30) - self.defenderInformation.size.width, y: 0)
    }
    private func createDiceRollDisplay(){
        self.attackerRoll = SpriteButton()
        self.attackerRoll.changeButtonSize(to: CGSize(width: 60, height: 60))
        self.attackerRoll.changeButtonText(to: "0")
        self.attackerRoll.position.x = self.attackerInformation.position.x
        self.attackerRoll.position.y = (self.attackerInformation.position.y - 100)
        self.attackerRoll.zPosition = 5
        self.attackerRoll.alpha = 0.7
        self.attackerRoll.isHidden = true
        self.attackerRoll.isUserInteractionEnabled = false
        
        self.defenderRoll = SpriteButton()
        self.defenderRoll.changeButtonSize(to: CGSize(width: 60, height: 60))
        self.defenderRoll.changeButtonText(to: "0")
        self.defenderRoll.position.x = self.defenderInformation.position.x + self.defenderInformation.size.width
        self.defenderRoll.position.y = (self.defenderInformation.position.y - 100)
        self.defenderRoll.zPosition = 5
        self.defenderRoll.alpha = 0.7
        self.defenderRoll.isHidden = true
        self.defenderRoll.isUserInteractionEnabled = false
    }
    
    func setCombatInformation(for attack: unitCombatStats, and def: unitCombatStats){
        self.attackerInformation.isUserInteractionEnabled = false
        self.attackerInformation.isHidden = false
        self.defenderInformation.isUserInteractionEnabled = false
        self.defenderInformation.isHidden = false
        self.attackerInformation.setLabel(for: attack)
        self.defenderInformation.setLabel(for: def)
    }
    
    func displayCurrentRolls(for attackeRoll:Int, defenderRoll: Int){
        self.attackerRoll.isHidden = false
        self.defenderRoll.isHidden = false
        let display = SKAction.sequence([SKAction.fadeAlpha(to: 0.7, duration: 0.2), SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 0.1)])
        self.attackerRoll.changeButtonText(to: "\(attackeRoll)")
        self.defenderRoll.changeButtonText(to: "\(defenderRoll)")
        
        self.attackerRoll.colorBlendFactor = 0.7
        self.attackerRoll.blendMode = .alpha
        self.defenderRoll.colorBlendFactor = 0.7
        self.defenderRoll.blendMode = .alpha
        
        if attackeRoll > defenderRoll {
            self.attackerRoll.color = SKColor.green
            self.defenderRoll.color = SKColor.red
        }else if attackeRoll < defenderRoll {
            self.attackerRoll.color = SKColor.red
            self.defenderRoll.color = SKColor.green
        }else{
            self.attackerRoll.color = SKColor.cyan
            self.defenderRoll.color = SKColor.cyan
        }
        self.attackerRoll.run(display)
        self.defenderRoll.run(display)
    }
    func displayCurrentStats(for unit: unitCombatStats){
        self.currentUnitStats.isHidden = false
        let display = SKAction.sequence([SKAction.fadeIn(withDuration: 0.25), SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 0.25)])
        self.currentUnitStats.setLabel(for: unit)
        self.currentUnitStats.run(display, completion: { () in })
    }

    func clearCombatInformation(){
        self.attackerInformation.isHidden = true
        self.defenderInformation.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.retreatButton = aDecoder.decodeObject(forKey: "retreatButton") as? SpriteButton!
        self.confirmAttackButton = aDecoder.decodeObject(forKey: "confirmAttackButton") as? SpriteButton!
        self.resolveAll = aDecoder.decodeObject(forKey: "resolveAll") as? SpriteButton!
        
        self.attackerInformation = aDecoder.decodeObject(forKey: "attackerInfo") as? CombatLabel!
        self.defenderInformation = aDecoder.decodeObject(forKey: "defenderInfo") as? CombatLabel!
        
        self.currentUnitStats = aDecoder.decodeObject(forKey: "currentUnitStats") as? CombatLabel!
        self.attackerRoll = aDecoder.decodeObject(forKey: "attackerRoll") as? SpriteButton!
        self.defenderRoll = aDecoder.decodeObject(forKey: "defenderRoll") as? SpriteButton!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.retreatButton, forKey: "retreatButton")
        aCoder.encode(self.confirmAttackButton, forKey: "confirmAttackButton")
        aCoder.encode(self.resolveAll, forKey: "resolveAll")
        aCoder.encode(self.attackerInformation, forKey: "attackerInfo")
        aCoder.encode(self.defenderInformation, forKey: "defenderInfo")
        aCoder.encode(self.currentUnitStats, forKey: "currentUnitStats")
        aCoder.encode(self.attackerRoll, forKey: "attackerRoll")
        aCoder.encode(self.defenderRoll, forKey: "defenderRoll")
    }
}
