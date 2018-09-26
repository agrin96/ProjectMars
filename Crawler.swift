//
//  Crawler.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/30/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class crawler: SKSpriteNode {
    var crawlerNumber:SKLabelNode!
    var tapZone:SKShapeNode!
    
    var attackState:(origin: Province, destination: Province, attacking: Bool, attacked: Bool)?
    var hasMoved:Bool = false
    var combatStats:unitCombatStats!
    
    init(){
        let crawlerImage = SKTexture(imageNamed: "Button_BG_final")
        super.init(texture: crawlerImage, color: SKColor.clear, size: CGSize(width: 30, height: 30))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.tapZone = SKShapeNode(rect: CGRect(x: -self.size.width * 1.5, y: -self.size.height * 1.5, width: self.size.width * 3, height: self.size.height * 3))
        self.tapZone.strokeColor = SKColor.clear
        
        self.crawlerNumber = SKLabelNode(text: String(1))
        self.crawlerNumber.fontName = "AvenirNext-Bold"
        self.crawlerNumber.fontSize = 18
        self.crawlerNumber.fontColor = SKColor.white
        self.crawlerNumber.position = CGPoint(x: 0, y: -7)
        self.name = "crawler"
        self.addChild(self.crawlerNumber)
        self.addChild(self.tapZone)
        self.combatStats = unitCombatStats()
        self.combatStats.setForCrawler()
    }
    
    convenience init(player: Player){
        self.init()
        self.crawlerNumber.fontColor = player.color
        self.name = "crawler-\(player.playerName!)"
    }
    
    
    /// Changes the stack of crawlers to indicate changes in number of crawlers on a province
    ///
    /// - Parameter numberOfCrawlers: the delta by which to change the stack
    func addCrawlersToStack(numberOfCrawlers: Int){
        var currentNumber = Int(self.crawlerNumber.text!)!
        currentNumber += numberOfCrawlers
        if currentNumber <= 0 {
            currentNumber = 0
            self.destroyStack()
        }
        self.crawlerNumber.text = String(currentNumber)
        self.combatStats.currentHitPoints = ( 2 * currentNumber)
    }
    
    func destroyStack(){
        self.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.crawlerNumber = aDecoder.decodeObject(forKey: "crawlerNumber") as? SKLabelNode!
        self.tapZone = aDecoder.decodeObject(forKey: "tapZone") as? SKShapeNode!
        
        self.attackState = aDecoder.decodeObject(forKey: "attackState") as? (origin: Province, destination: Province, attacking: Bool, attacked: Bool)
        self.hasMoved = aDecoder.decodeBool(forKey: "hasMoved")
        self.combatStats = aDecoder.decodeObject(forKey: "combatStats") as? unitCombatStats!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.crawlerNumber, forKey: "crawlerNumber")
        aCoder.encode(self.tapZone, forKey: "tapZone")
        aCoder.encode(self.attackState, forKey: "attackState")
        aCoder.encode(self.hasMoved, forKey: "hasMoved")
        aCoder.encode(self.combatStats, forKey: "combatStats")
    }
}
