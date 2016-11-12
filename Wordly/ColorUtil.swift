//
//  ColorUtil.swift
//  Wordly
//
//  Created by eposta developer on 28/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//


import UIKit

struct ColorUtil {
    
    
    
    //# MARK: - Set Borders
    static func borderButtonDefaultRadius(button : UIButton, uiColor : UIColor ) -> () {
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 2
        button.layer.borderColor = uiColor.CGColor
    }
    
    static func borderButtonWithRadius(button : UIButton, radius: CGFloat,uiColor : UIColor ) -> () {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = 2
        button.layer.borderColor = uiColor.CGColor
    }
    
    static func borderButtonWidthWithRadius(button : UIButton, width:CGFloat ,radius: CGFloat,uiColor : UIColor ) -> () {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = width
        button.layer.borderColor = uiColor.CGColor
    }
    
    //# MARK: - Get Day Colors 
    static func getColorOfTheDay(weekday : Int)  -> UIColor{
    
        switch weekday {
        case 1:
            return sunday
        case 2:
            return monday
        case 3:
            return tuesday
        case 4:
            return wednesday
        case 5:
            return thursday
        case 6 :
            return friday
        case 7 :
            return saturday
        default :
            return sunday
        }
      
    }
    
    static func getColorOfTheDay()  -> UIColor{
        
        let weekDay = DateUtil.getDayOfTheWeek()
        switch weekDay {
        case 1:
            return sunday
        case 2:
            return monday
        case 3:
            return tuesday
        case 4:
            return wednesday
        case 5:
            return thursday
        case 6 :
            return friday
        case 7 :
            return saturday
        default :
            return sunday
        }
        
    }
    
    //# MARK: - Class Variables / Members
    static let sunday : UIColor = UIColor( red: (232.0/255.0), green: (76.0/255.0), blue: (61.0/255.0), alpha: 1.0 ); //(232, 76, 61)
    
    static let monday : UIColor = UIColor( red: (230.0/255.0), green: (127.0/255.0), blue: (34.0/255.0), alpha: 1.0 ); //(230, 127, 34)
    
    static let tuesday : UIColor = UIColor( red: (53.0/255.0), green: (152.0/255.0), blue: (216.0/255.0), alpha: 1.0 ); //(53, 152, 216)
    
    static let wednesday : UIColor = UIColor( red: (45.0/255.0), green: (204.0/255.0), blue: (112.0/255.0), alpha: 1.0 ); //(45, 204, 112)
    
    static let thursday : UIColor = UIColor( red: (52.0/255.0), green: (73.0/255.0), blue: (94.0/255.0), alpha: 1.0 ); //(52, 73, 94)
    
    static let friday : UIColor = UIColor( red: (154.0/255.0), green: (89.0/255.0), blue: (181.0/255.0), alpha: 1.0 ); //(154, 89, 181)
    
    static let saturday : UIColor = UIColor( red: (27.0/255.0), green: (188.0/255.0), blue: (155.0/255.0), alpha: 1.0 ); //(27, 188, 155)
    
    static let blueButton : UIColor = UIColor( red: (29.0/255.0), green: (161.0/255.0), blue: (242.0/255.0), alpha: 1.0 ); //(29,161,242)
    
    static let blueButtonTappedBorder : UIColor = UIColor( red: (23.0/255.0), green: (128.0/255.0), blue: (193.0/255.0), alpha: 1.0 ); // (23,128,193)
    
    static let twitterButtonBorder : UIColor = UIColor( red: (85.0/255.0), green: (172.0/255.0), blue: (238.0/255.0), alpha: 1.0 );
    
    static let twitterButtonTappedBorder : UIColor = UIColor( red: (68.0/255.0), green: (137.0/255.0), blue: (190.0/255.0), alpha: 1.0 );
    
    static let facebookButtonBorder : UIColor = UIColor( red: (59.0/255.0), green: (89.0/255.0), blue: (152.0/255.0), alpha: 1.0 );
    
    static let facebookButtonTappedBorder : UIColor = UIColor( red: (47.0/255.0), green: (71.0/255.0), blue: (121.0/255.0), alpha: 1.0 );
    
    static let orangeButtonBorder : UIColor = UIColor( red: (182.0/255.0), green: (63.0/255.0), blue: (48.0/255.0), alpha: 1.0 );
    
    static let F2F2F2 : UIColor = UIColor( red: (242.0/255.0), green: (242.0/255.0), blue: (242.0/255.0), alpha: 1.0 );
    
    static let missedGreenBorder : UIColor = UIColor( red: (80.0/255.0), green: (174.0/255.0), blue: (1.0/255.0), alpha: 1.0 );
    
    static let missedYellowBorder : UIColor = UIColor( red: (159.0/255.0), green: (96.0/255.0), blue: (0.0/255.0), alpha: 1.0 );
    
    static let color282936 : UIColor = UIColor( red: (40.0/255.0), green: (41.0/255.0), blue: (54.0/255.0), alpha: 1.0 )
    
    static let colorB63F30 : UIColor = UIColor(red : (182.0/255.0), green : (63.0/255.0), blue: (48.0/255.0), alpha : 1.0 )
    
    static let color20202B : UIColor = UIColor(red : (32.0/255.0), green : (32.0/255.0), blue: (43.0/255.0), alpha : 1.0 )

    
    
    
}


