//
//  NibInitializable.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

protocol NibInitializable: class {
    static func fromNib() -> Self
}

extension NibInitializable where Self: UIView {
    static func fromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! Self
        
        return view
    }
}
