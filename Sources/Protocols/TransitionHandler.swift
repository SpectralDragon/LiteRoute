//
//  TransitionHandler.swift
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

/// This protocol describe how do transition beetwen ViewControllers.
public protocol TransitionHandler: class {
    
    ///
    /// The method of initiating the transition in the current storyboard, which depends on the root view controller.
    ///
    /// - Parameter identifier: Identifier of the view controller on the current storyboard.
    /// - Parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    /// - Returns: Transition node instance with setups.
    ///
    func forCurrentStoryboard<T>(restorationId: String, to type: T.Type) throws -> TransitionNode<T>
    
    ///
    /// Methods initaites transition for storyboard name and cast type and wait actions.
    ///
    /// - Parameter factory: StoryboardFactory inctance.
    /// - Parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    /// - Returns: Transition node instance with setups.
    ///
    func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) throws -> TransitionNode<T>
    
    ///
    /// Methods initiates transition from segue identifier and return transition node.
    ///
    /// - Parameter identifier: Segue identifier for transition.
    /// - Parameter type: Try cast destination controller to your type.
    /// - Returns: Transition node instance with setups.
    ///
    func forSegue<T>(identifier: String, to type: T.Type) -> SegueTransitionNode<T>
    
    ///
    /// Methods close current module.
    ///
    /// - Returns: Transition node instance with setups.
    ///
    func closeCurrentModule() -> CloseTransitionNode
}

