//
//  LightRouteErrors.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 03/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

import Foundation

public enum LightRouteError: LocalizedError {
    case castError(controller: String, type: String)
    case viewControllerWasNil(String)
    case customTransitionFail
    case storyboardWasNil
    case restorationId(String)
    case customError(String)
    
    public var localizedDescription: String {
        var message = ""
        switch self {
        case .castError(let controller, let type):
            message = "Can't cast type \"\(controller)\" to \(type) object"
        case .viewControllerWasNil(let controller):
            message = "\(controller) controller was nil"
        case .customTransitionFail:
            message = "Can't complete custom transition"
        case .storyboardWasNil:
            message = "Current storyboard was nil."
        case .restorationId(let identifier):
            message = "View controller with \(identifier) not found!"
        case .customError(let error):
            message = error
        }
        
        return "[LightRoute]: " + message
    }
    
    var errorDescription: String {
        
        var message = ""
        switch self {
        case .castError(let controller, let type):
            message = "Can't cast type \"\(controller)\" to \(type) object"
        case .viewControllerWasNil(let controller):
            message = "\(controller) controller was nil"
        case .customTransitionFail:
            message = "Can't complete custom transition"
        case .storyboardWasNil:
            message = "Current storyboard was nil."
        case .restorationId(let identifier):
            message = "View controller with \(identifier) not found!"
        case .customError(let error):
            message = error
        }
        
        return "[LightRoute]: " + message
    }
}
