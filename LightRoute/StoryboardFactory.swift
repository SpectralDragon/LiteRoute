//
//  StoryboardFactory.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 06/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//


/// This factory class a performs `StoryboardFactoryProtocol` and the instantiate transition view controller.
public struct StoryboardFactory: StoryboardFactoryProtocol {
    
    // MARK: -
    // MARK: Properties
    
    // MARK: Public
    /// Instantiate transition view controller.
    public func instantiateTransitionHandler() throws -> UIViewController {
        let controller = self.restorationId.isEmpty ? self.storyboard.instantiateInitialViewController() :
            self.storyboard.instantiateViewController(withIdentifier: self.restorationId)
        
        // If destination controller is nil then return error.
        guard let destination = controller else {
            throw LightRouteError.restorationId(self.restorationId)
        }
        
        return destination
    }
    
    // MARK: Private
    private var storyboard: UIStoryboard
    private var restorationId: String
    
    // MARK: -
    // MARK: Initialize
    
    ///
    /// Initialize Storyboard factory from `UIStoryboard` instance.
    ///
    /// - note: By default this init call `instantiateInitialViewController` instead `instantiateViewController(withIdentifier:)`
    /// if restorationId is empty.
    ///
    /// - parameter storyboard: Storyboard instance.
    /// - parameter restorationId: Restiration identifier for destination view controller.
    ///
    public init(storyboard: UIStoryboard, restorationId: String = "") {
        self.storyboard = storyboard
        self.restorationId = restorationId
    }
    
    ///
    /// Initialize Storyboard factory from Storyboard name.
    ///
    /// - note: By default this init call `instantiateInitialViewController` instead `instantiateViewController(withIdentifier:)`
    /// if restorationId is empty.
    ///
    /// - parameter storyboardName: The name of the storyboard resource file without the filename extension.
    /// - parameter bundle: The bundle containing the storyboard file and its related resources.
    /// If you specify nil, this method looks in the main bundle of the current application.
    /// - parameter restorationId: Restiration identifier for destination view controller.
    ///
    public init(storyboardName name: String, bundle: Bundle? = nil, restorationId: String = "") {
        self.storyboard = UIStoryboard(name: name, bundle: bundle)
        self.restorationId = restorationId
    }
}
