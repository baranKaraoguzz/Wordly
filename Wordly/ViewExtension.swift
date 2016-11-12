//
//  ViewExtension.swift
//  Wordly
//
//  Created by eposta developer on 28/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit


extension UIView {
    
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
