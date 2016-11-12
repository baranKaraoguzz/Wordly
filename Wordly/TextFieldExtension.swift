//
//  TextFieldExtension.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit


extension UITextField
{
 

}

class TextField : UITextField {
    
    override func drawRect(rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.moveToPoint(startingPoint)
        path.addLineToPoint(endingPoint)
        path.lineWidth = 2.0
        
       // tintColor.setStroke()
        UIColor.whiteColor().setStroke()
        
        path.stroke()
    }
}