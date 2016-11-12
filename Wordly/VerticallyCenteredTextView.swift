//
//  VerticallyCenteredTextView.swift
//  Wordly
//
//  Created by eposta developer on 27/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

public class VerticallyCenteredTextView : UITextView {

    override public var contentSize: CGSize {
    
        didSet {
        var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top:topCorrection, left:0,bottom:0,right: 0)
                    }
    }

}
