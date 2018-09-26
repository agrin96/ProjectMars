//
//  mainCamera.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/12/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerCamera:SKCameraNode {
    var hRange:SKRange!
    var vRange:SKRange!
    
    var maxZoom:CGFloat!
    var minZoom:CGFloat!
    
    var edgeConstraint:SKConstraint!
    
    var lastScale:CGFloat = 1.5
    
    var overlayHUD:overlayUI!
    
    override init(){
        super.init()
        //Default values
        self.changeZoomRange(max: 1.5, min: 0.5)
        self.changeScrollRange(hRange: SKRange(lowerLimit: 0, upperLimit: 750),
                               vRange: SKRange(lowerLimit: 0, upperLimit: 1334))
        self.createZoomConstraints()
        self.changeDefaultZoom(zoom: 1.5)

    }
    
    convenience init(hRange: SKRange, vRange: SKRange, maxZoom: CGFloat, minZoom: CGFloat){
        self.init()
        self.changeZoomRange(max: maxZoom, min: minZoom)
        self.changeScrollRange(hRange: hRange, vRange: vRange)
        self.createZoomConstraints()
        self.createScrollConstraints()
        self.changeDefaultZoom(zoom: maxZoom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.hRange = aDecoder.decodeObject(forKey: "hRange") as? SKRange!
        self.vRange = aDecoder.decodeObject(forKey: "vRange") as? SKRange!
        
        self.maxZoom = aDecoder.decodeObject(forKey: "maxZoom") as? CGFloat!
        self.minZoom = aDecoder.decodeObject(forKey: "minZoom") as? CGFloat!
        
        self.edgeConstraint = aDecoder.decodeObject(forKey: "edge") as? SKConstraint!
        self.lastScale = (aDecoder.decodeObject(forKey: "lastScale") as? CGFloat!)!
        self.overlayHUD = aDecoder.decodeObject(forKey: "overlayHUD") as? overlayUI!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.hRange, forKey: "hRange")
        aCoder.encode(self.vRange, forKey: "vRange")
        aCoder.encode(self.maxZoom, forKey: "maxZoom")
        aCoder.encode(self.minZoom, forKey: "minZoom")
        aCoder.encode(self.edgeConstraint, forKey: "edge")
        aCoder.encode(self.lastScale, forKey: "lastScale")
        aCoder.encode(self.overlayHUD, forKey: "overlayHUD")
        aCoder.encode(self.position, forKey: "position")
    }
    
    func changeScrollRange(hRange: SKRange, vRange: SKRange){
        self.hRange = hRange
        self.vRange = vRange
        //self.createScrollConstraints()
    }
    
    func changeZoomRange(max: CGFloat, min: CGFloat){
        self.maxZoom = max
        self.minZoom = min
    }
    
    func changeDefaultZoom(zoom: CGFloat){
        self.setScale(zoom)
    }
    
    private func createScrollConstraints() -> (){
        if self.hRange != nil && self.vRange != nil {
            self.edgeConstraint = SKConstraint.positionX(self.hRange, y: self.vRange)
            
            do { self.edgeConstraint.referenceNode = try gameState.sharedInstance().GameBoard.boardMap } catch { print("Error in CreateScrollConstraints") }
            self.constraints = [self.edgeConstraint]
        }else{
            return
        }
    }
    private func createZoomConstraints() -> (){
        if self.maxZoom != nil && self.minZoom != nil {
            if self.xScale > self.maxZoom {
                self.setScale(self.maxZoom)
            }
            if self.xScale < self.minZoom {
                self.setScale(self.minZoom)
            }
        }else{
            print("ERROR in createZoomConstraints")
            return
        }
    }
    
    public func createHUD(size: CGSize){
        self.overlayHUD = overlayUI(size: size)
        self.addChild(overlayHUD)
    }
}
