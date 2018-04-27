//
//  MainModel.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

struct MainModel {
    let transitionId: String
    let title: String
    let description: String
    let image: UIImage
}

extension Array where Element == MainModel {
    
    static var examples: [MainModel] {
        return [ MainModel(transitionId: "ex_default", title: "Default Transition", description: "All about default transition", image: #imageLiteral(resourceName: "mountains")),
                 MainModel(transitionId: "ex_nav", title: "Navigation Transition", description: "Little example demonstrate work with navigation controller", image: #imageLiteral(resourceName: "mountains")),
                 MainModel(transitionId: "ex_embed", title: "Embed Segue", description: "Simple example demonstrate how work EmbedSegue", image: #imageLiteral(resourceName: "mountains")),
                 MainModel(transitionId: "ex_transition", title: "Custom Transition", description: "Demonstrate work with custom transition", image: #imageLiteral(resourceName: "mountains")),
                 /* ExampleModel(exampleId: "ex_force", title: "Force touch", description: "", image: #imageLiteral(resourceName: "mountains")) */]
    }
    
    static var about: [MainModel] {
        return [ MainModel(transitionId: "ab_about", title: "About project", description: "", image: #imageLiteral(resourceName: "mountains")),
                 MainModel(transitionId: "ab_contr", title: "Our Contributors", description: "", image: #imageLiteral(resourceName: "mountains")) ]
    }
    
}
