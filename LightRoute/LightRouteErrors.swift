//
//  LightRouteErrors.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 03/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

import Foundation

/// Describe all error in LightRoute
public enum LightRouteError: LocalizedError {
    
    /// If operation could not be cast moduleInput or controller to type.
    case castError(controller: String, type: String)
    
    /// If need controller was nil.
    case viewControllerWasNil(String)
    
    /// If custon transition has error.
    case customTransitionFail
    
    /// If need storyboard was nil.
    case storyboardWasNil
    
    /// If storyboard could not find controller by restorationId.
    case restorationId(String)
    
    /// Something error.
    case customError(String)
    
    var errorDescription: String {
        
        switch self {
        case .castError(let controller, let type):
            return "[LightRoute]: Can't cast type \"\(controller)\" to \(type) object"
        case .viewControllerWasNil(let controller):
            return "[LightRoute]: \(controller) controller was nil"
        case .customTransitionFail:
            return "[LightRoute]: Can't complete custom transition"
        case .storyboardWasNil:
            return "[LightRoute]: Current storyboard was nil."
        case .restorationId(let identifier):
            return "[LightRoute]: View controller with \(identifier) not found!"
        case .customError(let error):
            return "[LightRoute]: " + error
        }
    }
}
