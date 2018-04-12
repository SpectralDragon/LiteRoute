//
//  ExampleModel.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

struct ExampleModel {
    let exampleId: String
    let title: String
    let description: String
    var color: UIColor
    var colors: GradientColors { return (self.color, self.color.darker) }
}

extension ExampleModel {
    
    static var `default`: [ExampleModel] {
        let randomIndex = Int(randomIn: 0...2)
        let themes = Style.Colors.Groups.exampleThemes[randomIndex]
        return [ ExampleModel(exampleId: "ex_default", title: "Default Transition", description: "All about default transition", color: themes[0]),
                 ExampleModel(exampleId: "ex_nav", title: "Navigation Transition", description: "", color: themes[1]),
                 ExampleModel(exampleId: "ex_embed", title: "Embed Segue", description: "", color: themes[2]),
                 ExampleModel(exampleId: "ex_transition", title: "Custom Transition", description: "", color: themes[3]),
                 ExampleModel(exampleId: "ex_force", title: "Force touch", description: "", color: themes[4])]
    }
    
}

fileprivate extension Int {
    init(randomIn range: ClosedRange<Int>) {
        self.init(arc4random_uniform(UInt32(range.upperBound)) + UInt32(range.lowerBound))
    }
}
