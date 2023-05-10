//
//  Person.swift
//  VirusSpreadSimulator
//
//  Created by Данил Швец on 05.05.2023.
//

import UIKit

class Person {
    
    var color: CGColor?
    var isInfected: Bool
    var coordinates: CGPoint
    var id: Int
    
    init(color: CGColor?, isInfected: Bool, coordinates: CGPoint, id: Int) {
        self.color = color
        self.isInfected = isInfected
        self.coordinates = coordinates
        self.id = id
    }
    
    func drawCircle() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let circle = UIBezierPath(ovalIn: rect)
        shapeLayer.path = circle.cgPath
        
        shapeLayer.fillColor = color
        
        shapeLayer.position = coordinates
        shapeLayer.name = "\(coordinates.x)\(coordinates.y)"
        
        return shapeLayer
    }
    
}
