//
//  LabelExtension.swift
//  Wordly
//
//  Created by eposta developer on 14/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit



class InsetLabel: UILabel {
    let topInset = CGFloat(12.0), bottomInset = CGFloat(12.0), leftInset = CGFloat(12.0), rightInset = CGFloat(12.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}



class UnderlinedLabel : UILabel {

    override var text: String! {
        
        didSet{
        
        let textRange = NSMakeRange(0, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
            self.attributedText = attributedText
        
        }
    }
}