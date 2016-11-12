//
//  ButtonExtension.swift
//  Wordly
//
//  Created by eposta developer on 01/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit
import FBSDKLoginKit


//# TODO: - Facebook Login Button Styles

public class BlueButton : UIButton{}

extension BlueButton {

    override public var highlighted: Bool {
        didSet {
            if highlighted {
           
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.blueButtonTappedBorder.CGColor
            } else {
             
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.blueButton.CGColor
            }
        }
    }
    
}



extension FBSDKLoginButton {

    override public var highlighted: Bool {
        didSet {
            if highlighted {
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.facebookButtonTappedBorder.CGColor
            } else {
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.facebookButtonBorder.CGColor
            }
        }
    }
}

public class FacebookButton : UIButton{}

extension FacebookButton {
    
    override public var highlighted: Bool {
        didSet {
            if highlighted {
                
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.facebookButtonTappedBorder.CGColor
            } else {
                
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.facebookButtonBorder.CGColor
                
            }
        }
    }
    
}
public class TwitterButton : UIButton{}

extension TwitterButton {
    
    override public var highlighted: Bool {
        didSet {
            if highlighted {
                
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.twitterButtonTappedBorder.CGColor
            } else {
                
                layer.cornerRadius = 7
                layer.borderWidth = 2
                layer.borderColor = ColorUtil.twitterButtonBorder.CGColor
                
            }
        }
    }
    
}