//
//  GenericTransitionNode.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 25/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

/// This class is main frame to transition's
public class GenericTransitionNode<T> {
	
	// Main transition data.
	internal unowned var root: UIViewController
	internal var destination: UIViewController?
	internal var type: T.Type
	
    /// Contain moduleInput, if user wanna use custom selector
	internal var customModuleInput: Any?
	
	/// Wait transition post action.
	internal var postLinkAction: TransitionPostLinkAction?
	
	// MARK: -
	// MARK: Initialize

	///
    /// Initialize transition node for current transition.
    ///
    /// - Parameters:
    ///   - root: The root view controller.
    ///   - destination: The view controller at which the jump occurs.
    ///   - type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    ///
	init(root: UIViewController, destination: UIViewController?, for type: T.Type) {
		self.root = root
		self.destination = destination
		self.type = type
	}
	
	///
	/// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
	///
    /// - Parameter block: Initialize controller for transition and fire.
    /// - Throws: Throw error, if destination was nil or could not be cast to type.
    ///
	open func then(_ block: @escaping TransitionSetupBlock<T>) throws {
		guard let destination = self.destination else { throw LightRouteError.viewControllerWasNil("Destination") }
		
		var moduleInput: Any? = (self.customModuleInput != nil) ? self.customModuleInput : destination.moduleInput
		
		// If first controller was UINavigationController, then try find top view controller.
		if destination is UINavigationController {
			let result = (destination as! UINavigationController).topViewController ?? destination
			moduleInput = (self.customModuleInput != nil) ? self.customModuleInput : result.moduleInput
		}
		
		var moduleOutput: Any?
		
		if moduleInput is T {
			moduleOutput = block(moduleInput as! T)
		} else if destination is T {
			moduleOutput = block(destination as! T)
		} else {
			throw LightRouteError.castError(controller: .init(describing: T.self), type: "\(moduleInput as Any)")
		}
		
		self.destination?.moduleOutput = moduleOutput
		try self.perform()
	}
	
	/// This method makes a current transition.
	public func perform() throws {
		try self.postLinkAction?()
	}
    
    ///
    /// Methods return in clousure view controller for configure something.
    ///
    /// - Parameter block: UIViewController for configure.
    /// - Returns: Return current transition node.
    /// - Throws: Throw error, if destination was nil.
    ///
    public func apply(to block: (UIViewController) -> Void) throws -> Self {
        guard let destination = self.destination else { throw LightRouteError.viewControllerWasNil("Destination") }
        block(destination)
        return self
    }
	
	// MARK: -
	// MARK: Private methods
	
	///
	/// This method waits to be able to fire.
	/// - Parameter completion: Whait push action from `TransitionPromise` class.
	///
	func postLinkAction( _ completion: @escaping TransitionPostLinkAction) {
		self.postLinkAction = completion
	}
}
