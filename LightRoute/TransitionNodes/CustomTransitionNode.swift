//
//  CustomTransitionNode.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 25/10/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//

/// The class is responsible for what the user has implemented the transition.
public final class CustomTransitionNode<T> {
	
	private unowned var root: UIViewController
	private var destination: UIViewController?
	private var type: T.Type
	
	internal var customModuleInput: Any?
	
	///
	/// Initialize custom transition node. This class is responsible for the fact that the user will carry out necessary transition.
	///
	/// - parameter root: The view controller from which the transition.
	/// - parameter destination: The view controller at which the jump occurs.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	///
	init(root: UIViewController, destination: UIViewController?, for type: T.Type) {
		self.root = root
		self.destination = destination
		self.type = type
	}
	
	///
	/// This method is responsible for that the user realizes the transition
	/// - parameter block: User transition implementation.
	/// - returns: Transition node instance with setups.
	///
	public func transition(_ block: @escaping TransitionBlock) -> GenericTransitionNode<T> {
		
		let node = GenericTransitionNode(root: root, destination: destination, for: type)
		
		node.postLinkAction {
			block(self.root, self.destination!)
		}
		
		return node
	}
	
	///
	/// This methods is responsible for find selector in destination view controller
	/// for configure.
	///
	/// - Parameter selector: String selector for configure module.
	/// - Returns: Transition node instance with setups.
	///
	public func custom(selector: String) -> CustomTransitionNode<T> {
		self.customModuleInput = destination?.getModuleInput(for: selector)
		return self
	}
	
	///
	/// This methods is responsible for find selector in destination view controller
	/// for configure.
	///
	/// - Parameter selector: Selector for configure module.
	/// - Returns: Transition node instance with setups.
	///
	public func custom(selector: Selector) -> CustomTransitionNode<T> {
		self.customModuleInput = destination?.getModuleInput(for: NSStringFromSelector(selector))
		return self
	}

	///
	/// This methods is responsible for find selector in destination view controller
	/// for configure.
	///
	/// - Parameter selector: Key path for selector.
	/// - Returns: Transition node instance with setups.
	///
	public func custom<Root, Type>(selector: KeyPath<Root, Type>) -> CustomTransitionNode<T> {
		self.customModuleInput = destination[keyPath: selector]
		return self
	}
}
