//
//  DefaultModel.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import Foundation

enum DefaultModel: Int {
    
    case current, factory, segue
    
    var description: String {
        switch self {
        case .current:
            return "Instantiate controller present new controller from current storyboard"
        case .factory:
            return "Instantiate controller, create new controller from fabric object"
        case .segue:
            return "Instantiate controller, present new controller from segue"
        }
    }
    
    init(_ integer: Int) {
        self = DefaultModel(rawValue: integer) ?? .current
    }
}

enum ModuleInputCases: Int {
    case `default`, keyPath, selector
    
    init(_ integer: Int) {
        self = ModuleInputCases(rawValue: integer) ?? .default
    }
}
