//
//  TransitionHandler.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 06/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

import Foundation

/// This protocol describe how do transition beetwen ViewControllers.
public protocol TransitionHandler: class {
    
    ///
    /// The method of initiating the transition in the current storyboard, which depends on the root view controller.
    ///
    /// - parameter identifier: Identifier of the view controller on the current storyboard.
    /// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    /// - returns: Transition promise class with setups.
    ///
    func forCurrentStoryboard<T>(resterationId: String, to type: T.Type) throws -> TransitionNode<T>
    
    ///
    /// Methods initaites transition for storyboard name and cast type and wait actions.
    ///
    /// - parameter factory: StoryboardFactory inctance.
    /// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    /// - returns: Transition promise class with setups.
    ///
    func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) throws -> TransitionNode<T>
    
    ///
    /// Methods initiates transition from segue identifier and return transition node.
    ///
    /// - parameter identifier: Segue identifier for transition.
    /// - parameter type: Try cast destination controller to your type.
    ///
    func forSegue<T>(identifier: String, to type: T.Type) -> SegueTransitionNode<T>
    
    ///
    /// Methods close current module.
    ///
    /// - parameter animated: Transition animate state.
    ///
    func closeModule(animated: Bool)
    
    ///
    /// Methods close all modules in Navigation Controller stack.
    ///
    /// - parameter animated: Transition animate state.
    ///
    func closeModulesInStack(animated: Bool)
}
