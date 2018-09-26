//
//  gamePiecePoints.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/16/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class gamePiecePositions{
    var extractorPoints:Array<CGPoint> = []
    var roverPoints:Array<CGPoint> = []
    
    init(){
        ///UpperLeft Continent
        self.extractorPoints.append(CGPoint(x: 37 ,y: 617))
        self.extractorPoints.append(CGPoint(x: 40 ,y: 520))
        self.extractorPoints.append(CGPoint(x: 159 ,y: 596))
        self.extractorPoints.append(CGPoint(x: 245 ,y: 544))
        self.extractorPoints.append(CGPoint(x: 303 ,y: 665))
        self.extractorPoints.append(CGPoint(x: 404 ,y: 624))
        self.extractorPoints.append(CGPoint(x: 549 ,y: 606))
        self.extractorPoints.append(CGPoint(x: 483 ,y: 550))
        self.extractorPoints.append(CGPoint(x: 501 ,y: 469))
        self.extractorPoints.append(CGPoint(x: 601 ,y: 548))
        self.extractorPoints.append(CGPoint(x: 721 ,y: 516))
        
        ///Center Continent
        self.extractorPoints.append(CGPoint(x: 418 ,y: 507))
        self.extractorPoints.append(CGPoint(x: 325 ,y: 375))
        self.extractorPoints.append(CGPoint(x: 414 ,y: 427))
        self.extractorPoints.append(CGPoint(x: 269 ,y: 296))
        
        ///LowerLeft Continent
        self.extractorPoints.append(CGPoint(x: 92 ,y: 295))
        self.extractorPoints.append(CGPoint(x: 135 ,y: 200)) 
        self.extractorPoints.append(CGPoint(x: 120 ,y: 96))
        self.extractorPoints.append(CGPoint(x: 176 ,y: 247))
        self.extractorPoints.append(CGPoint(x: 223 ,y: 109))
        self.extractorPoints.append(CGPoint(x: 304 ,y: 209))
        self.extractorPoints.append(CGPoint(x: 314 ,y: 75))
        self.extractorPoints.append(CGPoint(x: 429 ,y: 213))
        self.extractorPoints.append(CGPoint(x: 540 ,y: 121))
        self.extractorPoints.append(CGPoint(x: 546 ,y: 284))
        
        ///LowerRight Continent
        self.extractorPoints.append(CGPoint(x: 754 ,y: 223))
        self.extractorPoints.append(CGPoint(x: 939 ,y: 370))
        self.extractorPoints.append(CGPoint(x: 1026 ,y: 308))
        self.extractorPoints.append(CGPoint(x: 945 ,y: 187))
        self.extractorPoints.append(CGPoint(x: 819 ,y: 142))
        self.extractorPoints.append(CGPoint(x: 1051 ,y: 111))
        self.extractorPoints.append(CGPoint(x: 1126 ,y: 215))
        self.extractorPoints.append(CGPoint(x: 1126 ,y: 375))
        self.extractorPoints.append(CGPoint(x: 1267 ,y: 279))
        self.extractorPoints.append(CGPoint(x: 1270 ,y: 163))
        
        ///UpperRight Continent
        self.extractorPoints.append(CGPoint(x: 833 ,y: 620))
        self.extractorPoints.append(CGPoint(x: 994 ,y: 654))
        self.extractorPoints.append(CGPoint(x: 1039 ,y: 561))
        self.extractorPoints.append(CGPoint(x: 1203 ,y: 613))
        self.extractorPoints.append(CGPoint(x: 1296 ,y: 673))
        self.extractorPoints.append(CGPoint(x: 1304 ,y: 567))
        self.extractorPoints.append(CGPoint(x: 1157 ,y: 484))
        self.extractorPoints.append(CGPoint(x: 1004 ,y: 429))
        
        ///****************************************************///
        ///*********************SEPERATOR**********************///
        ///****************************************************///
        
        ///UpperLeft Continent
        self.roverPoints.append(CGPoint(x: 86, y: 670))
        self.roverPoints.append(CGPoint(x: 134, y: 509))
        self.roverPoints.append(CGPoint(x: 230, y: 653))
        self.roverPoints.append(CGPoint(x: 303, y: 561))
        self.roverPoints.append(CGPoint(x: 381, y: 681))
        self.roverPoints.append(CGPoint(x: 343, y: 613))
        self.roverPoints.append(CGPoint(x: 479, y: 643))
        self.roverPoints.append(CGPoint(x: 402, y: 570))
        self.roverPoints.append(CGPoint(x: 570, y: 483))
        self.roverPoints.append(CGPoint(x: 643, y: 572))
        self.roverPoints.append(CGPoint(x: 657, y: 493))
        
        ///Center Continent
        self.roverPoints.append(CGPoint(x: 346, y: 516))
        self.roverPoints.append(CGPoint(x: 336, y: 448))
        self.roverPoints.append(CGPoint(x: 434, y: 386))
        self.roverPoints.append(CGPoint(x: 364, y: 312))
        
        ///LowerLeft Continent
        self.roverPoints.append(CGPoint(x: 92, y: 245))
        self.roverPoints.append(CGPoint(x: 135, y: 150))
        self.roverPoints.append(CGPoint(x: 172, y: 75))
        self.roverPoints.append(CGPoint(x: 229, y: 236))
        self.roverPoints.append(CGPoint(x: 239, y: 168))
        self.roverPoints.append(CGPoint(x: 327, y: 232))
        self.roverPoints.append(CGPoint(x: 429, y: 109))
        self.roverPoints.append(CGPoint(x: 456, y: 288))
        self.roverPoints.append(CGPoint(x: 515, y: 163))
        self.roverPoints.append(CGPoint(x: 630, y: 192))
        
        ///lowerRight Continent
        self.roverPoints.append(CGPoint(x: 663, y: 264))
        self.roverPoints.append(CGPoint(x: 852, y: 298))
        self.roverPoints.append(CGPoint(x: 945, y: 299))
        self.roverPoints.append(CGPoint(x: 868, y: 209))
        self.roverPoints.append(CGPoint(x: 911, y: 121))
        self.roverPoints.append(CGPoint(x: 1150, y: 84))
        self.roverPoints.append(CGPoint(x: 1098, y: 282))
        self.roverPoints.append(CGPoint(x: 1191, y: 406))
        self.roverPoints.append(CGPoint(x: 1217, y: 302))
        self.roverPoints.append(CGPoint(x: 1258, y: 85))
        
        ///UpperRightContinent
        self.roverPoints.append(CGPoint(x: 847, y: 558))
        self.roverPoints.append(CGPoint(x: 1075, y: 674))
        self.roverPoints.append(CGPoint(x: 1000, y: 525))
        self.roverPoints.append(CGPoint(x: 1130, y: 622))
        self.roverPoints.append(CGPoint(x: 1251, y: 679))
        self.roverPoints.append(CGPoint(x: 1225, y: 541))
        self.roverPoints.append(CGPoint(x: 1105, y: 520))
        self.roverPoints.append(CGPoint(x: 1072, y: 458))
        
        
    }
}
