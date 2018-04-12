//
//  Configurable.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import Foundation

protocol Configurable: class {
    associatedtype Item
    func configure(with item: Item)
}
