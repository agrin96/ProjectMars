//
//  Province.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/4/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import SpriteKit


/// This class is responsible for creating all of the provinces in the game. Each province is numbered as an identifier and has its own sprite representation. Adjacent provinces are represented in an array of province identifiers (this is determined manually).
class Province : SKNode{
    var provinceNumber:Int = 1
    var provinceImage:SKSpriteNode!
    var tapOutline:SKShapeNode!
    
    var extractorPosition:CGPoint!
    var landShipPosition:CGPoint!
    
    var startPositionTaken:Bool = false
    var isCratered:Bool = false
    var hasExtractor:Bool = false
    var hasCrawlers:Bool = false
    var hasLandShip:Bool = false
    
    var owningPlayer:Player?
    
    override init(){
        super.init()
        self.provinceNumber = 1
        self.extractorPosition = CGPoint(x: 0, y: 0)
        self.landShipPosition = CGPoint(x: 0, y: 0)
        
    }
    convenience init(provNum: Int, provSprite: SKTexture, size: CGSize){
        self.init()
        self.provinceNumber = provNum
        self.provinceImage = SKSpriteNode(texture: provSprite)
        self.provinceImage.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.provinceImage.size = size
        self.provinceImage.color = SKColor.clear
        self.addChild(self.provinceImage)

    }
    
    func setupTappableArea(path: CGMutablePath){
        self.tapOutline = SKShapeNode(path: path)
        self.tapOutline.strokeColor = SKColor.clear
        self.tapOutline.setScale(2.0)
        self.tapOutline.name = "tapOutline"
        self.provinceImage.addChild(self.tapOutline)
    }
    
    func changeProvinceColor(toColor: SKColor, toBlendMode: SKBlendMode, toFactor: CGFloat){
        self.provinceImage.color = toColor
        self.provinceImage.blendMode = toBlendMode
        self.provinceImage.colorBlendFactor = toFactor
        do { try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.hasOwnerShipChanged = true } catch { print("Error in changeProvinceColor") }
    }
    
    func setupGamePiecePositions(extractor: CGPoint, landship: CGPoint){
        self.extractorPosition = extractor
        self.landShipPosition = landship
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = Province(provNum: self.provinceNumber, provSprite: self.provinceImage.texture!, size: self.provinceImage.size)
        copy.tapOutline = self.tapOutline.copy() as! SKShapeNode
        copy.changeProvinceColor(toColor: self.provinceImage.color, toBlendMode: self.provinceImage.blendMode, toFactor: self.provinceImage.colorBlendFactor)
        copy.setupGamePiecePositions(extractor: self.extractorPosition, landship: self.landShipPosition)
        return copy
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.provinceNumber = aDecoder.decodeInteger(forKey: "number")
        self.provinceImage = aDecoder.decodeObject(forKey: "image") as? SKSpriteNode!
        self.tapOutline = aDecoder.decodeObject(forKey: "outline") as? SKShapeNode!
        
        self.extractorPosition = aDecoder.decodeObject(forKey: "extractorPos") as? CGPoint
        self.landShipPosition = aDecoder.decodeObject(forKey: "landshipPos") as? CGPoint
        
        self.startPositionTaken = aDecoder.decodeBool(forKey: "startPositionTaken")
        self.isCratered = aDecoder.decodeBool(forKey: "isCratered")
        self.hasExtractor = aDecoder.decodeBool(forKey: "hasExtractor")
        self.hasCrawlers = aDecoder.decodeBool(forKey: "hasCrawlers")
        self.hasLandShip = aDecoder.decodeBool(forKey: "hasLandship")
        
        self.owningPlayer = aDecoder.decodeObject(forKey: "owningPlayer") as? Player

    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.provinceNumber, forKey: "number")
        aCoder.encode(self.provinceImage, forKey: "image")
        aCoder.encode(self.tapOutline, forKey: "outline")
        aCoder.encode(self.extractorPosition, forKey: "extractorPos")
        aCoder.encode(self.landShipPosition, forKey: "landshipPos")
        aCoder.encode(self.startPositionTaken, forKey: "startPositionTaken")
        aCoder.encode(self.isCratered, forKey: "isCratered")
        aCoder.encode(self.hasExtractor, forKey: "hasExtractor")
        aCoder.encode(self.hasCrawlers, forKey: "hasCrawlers")
        aCoder.encode(self.hasLandShip, forKey: "hasLandship")
        if owningPlayer != nil {
            let savePlayer:Player = self.owningPlayer!
            aCoder.encode(savePlayer, forKey: "owningPlayer")
        }
    }
}
