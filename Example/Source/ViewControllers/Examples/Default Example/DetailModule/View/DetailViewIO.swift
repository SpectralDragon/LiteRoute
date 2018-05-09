//
//  DetailViewIO.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import Foundation

protocol DetailViewInput: class {
    func setText(_ text: String)
}

@objc protocol DetailViewOutput: class {
    func onViewDidLoad()
    func onClose()
}
