//
//  NavigationModel.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import LightRoute

struct NavigationModel {
    let type: TransitionStyle.NavigationStyle
    let title: String
    let transitionIdentifier: String
    
    init(type: TransitionStyle.NavigationStyle) {
        self.type = type
        self.title = type.name
        self.transitionIdentifier = type.transitionIdentifier
    }
}

extension Array where Element == NavigationModel {
    
    static var mock: [Element] {
        return [NavigationModel(type: .push), NavigationModel(type: .present)]
    }
    
}

fileprivate extension TransitionStyle.NavigationStyle {
    
    var name: String {
        switch self {
        case .push: return "Push"
        case .present: return "Present"
        default: return ""
        }
    }

    var transitionIdentifier: String {
        return "tr_" + self.name.lowercased()
    }
    
}
