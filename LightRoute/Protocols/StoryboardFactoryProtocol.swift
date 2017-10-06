//
//  StoryboardFactoryProtocol.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 06/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

import Foundation

/// This protocol a describe that destination controller should be returns.
public protocol StoryboardFactoryProtocol: class {
    
    /// Instantiate transition view controller.
    func instantiateTransitionHandler() throws -> UIViewController
}
