//
//  Stylization.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/3/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func setMainBackgroundwithFit(backgroundName: String){
        let bgImage = UIImage(named: backgroundName)!
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        let imageFrame = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        imageFrame.image = bgImage
        self.addSubview(imageFrame)
        self.sendSubview(toBack: imageFrame)
    }
    
    func setSecondaryBackground(named: String){
        let bgImage = UIImage(named: named)!
        
        let imageRect = self.bounds
        let imageFrame = UIImageView(frame: imageRect)
        imageFrame.image = bgImage
        self.addSubview(imageFrame)
        self.sendSubview(toBack: imageFrame)
    }
}


extension UILabel{
    func setLabelBackground(backgroundName: String){
        let bgImage = UIImage(named: backgroundName)!
        let height = self.bounds.height
        let width = self.bounds.width
        
        UIGraphicsBeginImageContext(self.bounds.size)
        bgImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height),blendMode: CGBlendMode.colorBurn, alpha: 0.9)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: image!)
    }
}

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
}



