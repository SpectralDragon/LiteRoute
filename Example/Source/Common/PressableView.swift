//
//  PressableView.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class PressableView: UIView, PressStateAnimatable {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPressStateAnimationEnabled = true
    }
    
}
