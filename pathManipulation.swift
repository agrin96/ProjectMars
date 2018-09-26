//
//  pathManipulation.swift
//  project-mars
//
//  Created by Aleksandr Grin on 2/2/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit


/// This enum is needed because the regular CGPathElement is imported as an UnsafeMutablePointer which is
/// not reccomended to be worked with in swift. (hence the unsafe). This function takes the CGPathElement
/// and stores it within our customPathElement which is more swifty.
public enum customPathElement {
    case moveToPoint(position: CGPoint)
    case addLineToPoint(position: CGPoint)
    case addQuadCurveToPoint(start: CGPoint,end: CGPoint)
    case addCurveToPoint(start: CGPoint,mid: CGPoint,end: CGPoint)
    case closeSubpath
    
    init(element: CGPathElement) {
        switch element.type {
        case .moveToPoint:
            self = .moveToPoint(position: element.points[0])
        case .addLineToPoint:
            self = .addLineToPoint(position: element.points[0])
        case .addQuadCurveToPoint:
            self = .addQuadCurveToPoint(start: element.points[0],end: element.points[1])
        case .addCurveToPoint:
            self = .addCurveToPoint(start: element.points[0],mid: element.points[1],end: element.points[2])
        case .closeSubpath:
            self = .closeSubpath
        }
    }
    
    func getValue() -> (start: CGPoint?,mid: CGPoint?,end: CGPoint?){
        switch self {
        case let .moveToPoint(position):
            return (position, nil, nil)
        case let .addLineToPoint(position):
            return (position, nil, nil)
        case let .addQuadCurveToPoint(start, end):
            return (start, end, nil)
        case let .addCurveToPoint(start, mid, end):
            return (start, mid, end)
        case .closeSubpath:
            return (nil, nil, nil)
        }
    }
}

/// We make our customPathElements equatable as per swift style guides
extension customPathElement: Equatable {
    public static func ==(lhs: customPathElement, rhs: customPathElement) -> Bool {
        switch(lhs, rhs) {
        case let (.moveToPoint(l), .moveToPoint(r)):
            return l == r
        case let (.addLineToPoint(l), .addLineToPoint(r)):
            return l == r
        case let (.addQuadCurveToPoint(l1, l2), .addQuadCurveToPoint(r1, r2)):
            return l1 == r1 && l2 == r2
        case let (.addCurveToPoint(l1, l2, l3), .addCurveToPoint(r1, r2, r3)):
            return l1 == r1 && l2 == r2 && l3 == r3
        case (.closeSubpath, .closeSubpath):
            return true
        case (_, _):
            return false
        }
    }
}

extension UIBezierPath {
    var elements: [customPathElement] {
        var pathElements = [customPathElement]()
        
        withUnsafeMutablePointer(to: &pathElements) { elementsPointer in
            let rawElementsPointer = UnsafeMutableRawPointer(elementsPointer)
            
            cgPath.apply(info: rawElementsPointer) { userInfo, nextElementPointer in
                let nextElement = customPathElement(element: nextElementPointer.pointee)
                let elementsPointer = userInfo?.assumingMemoryBound(to: [customPathElement].self)
                elementsPointer?.pointee.append(nextElement)
            }
        }
        return pathElements
    }
}


extension UIBezierPath: Sequence {
    public func makeIterator() -> AnyIterator<customPathElement> {
        return AnyIterator(elements.makeIterator())
    }
}

