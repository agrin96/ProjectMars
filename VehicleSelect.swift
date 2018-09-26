//
//  VehicleSelect.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/17/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class vehicleSelect: SKScene{
    var mainCamera:PlayerCamera!
    var panRecognizer:UIPanGestureRecognizer!
    var tapRecognizer:UITapGestureRecognizer!

    var vehicleList:Array<(landShip: landship,extractor: extractor)> = []
    
    override init(size: CGSize){
        super.init(size: size)
        addVehicleSelectionRow(numberofTimes: 6)
        
        /// Adds an initial player label that appears before user makes any player cahnges.
        let label = SKLabelNode(text: "Player\(1)")
        label.fontSize = 24
        label.fontColor = SKColor.white
        label.fontName = "System Heavy"
        label.position = CGPoint(x: vehicleList[0].landShip.position.x - 50,
                                 y: vehicleList[0].landShip.position.y + 50)
        label.zPosition = 1
        label.name = "initlabel"
        vehicleList[(0)].landShip.landShipSprite.addChild(label)
        
        createCamera()
    }
    
    /// Adds a row of landships to the selection screen at correct ofsets.
    ///
    /// - Parameter numberofTimes: Describes how many rows to create.
    func addVehicleSelectionRow(numberofTimes: Int){
        self.removeAllChildren()
        self.vehicleList.removeAll()
        for i in 0..<numberofTimes {
            addVehicleSet(landShipAtlas: "FactoryRover", extractorAtlas: "Extractor", xoffset: 0, yoffset: CGFloat(i) * -200)
            addVehicleSet(landShipAtlas: "JapaneseRover", extractorAtlas: "JapaneseExtractor", xoffset: 300, yoffset: CGFloat(i) * -200)
            addVehicleSet(landShipAtlas: "RussianRover", extractorAtlas: "RussianExtractor", xoffset: 600, yoffset: CGFloat(i) * -200)
        }
    }
    
    /// Creates the main camera view for the game screen
    private func createCamera(){
        let vRange = SKRange(lowerLimit: 0,
                             upperLimit: 0)
        let hRange = SKRange(lowerLimit: 0,
                             upperLimit: (200 * CGFloat(3)))
        
        mainCamera = PlayerCamera(hRange: hRange,
                                  vRange: vRange,
                                  maxZoom: 1,
                                  minZoom: 1)
        mainCamera.position = CGPoint(x: 0,
                                      y: 0)
        self.camera = mainCamera
        self.addChild(mainCamera)
    }
    
    
    /// Generates the correct sprites to place in a selection row.
    ///
    /// - Parameters:
    ///   - landShipAtlas: The name of the atlas to use to generate a landship sprite.
    ///   - extractorAtlas: The name of the atlas to use to generate an extractor sprite.
    ///   - xoffset: Distance between the sprites in a row
    ///   - yoffset: Distance between rows of sprites.
    private func addVehicleSet(landShipAtlas: String, extractorAtlas: String, xoffset: CGFloat, yoffset: CGFloat){
        var atlas = SKTextureAtlas(named: landShipAtlas)
        let vehicle = landship(landShipAtlas: atlas)
        vehicle.modifySpawnPosition(position: CGPoint(x: 0 + xoffset, y: 0 + yoffset))
        if landShipAtlas == "FactoryRover"{
            vehicle.modifyLandShipSize(newSize: CGSize(width: 200, height: 200))
        }
        if landShipAtlas == "JapaneseRover" {
            vehicle.modifyLandShipSize(newSize: CGSize(width: 220, height: 220))
        }
        if landShipAtlas == "RussianRover" {
            vehicle.modifyLandShipSize(newSize: CGSize(width: 240, height: 240))
        }
        self.addChild(vehicle)
        
        atlas = SKTextureAtlas(named: extractorAtlas)
        let Extractor = extractor(extractorAtlas: atlas)
        Extractor.modifySpawnPosition(position: CGPoint(x: vehicle.landShipSprite.position.x + 50, y: vehicle.landShipSprite.position.y - 50))
        //Extractor.modifyExtractorSize(newSize: CGSize(width: 100, height: 100))
        self.addChild(Extractor)
        
        vehicleList.append((vehicle, Extractor))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
