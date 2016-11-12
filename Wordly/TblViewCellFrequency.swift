//
//  TblViewCellFrequency.swift
//  Wordly
//
//  Created by eposta developer on 02/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import UIKit

class TblViewCellFrequency: UITableViewCell {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.imgTick.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        debugPrint("selected ")
      //  if imgTick.hidden
        
    }

   
    //
    @IBOutlet weak var lblFreq : UILabel!
    @IBOutlet weak var imgTick : UIImageView!
    var isSelectedImg : Bool = false
}
