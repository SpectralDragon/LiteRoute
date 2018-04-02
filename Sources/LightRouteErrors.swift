//
//  LightRouteErrors.swift
//  LightRoute
//
//  Copyright © 2016-2017 Vladislav Prusakov <hipsterknights@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

    var localizedDescription: String {
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
