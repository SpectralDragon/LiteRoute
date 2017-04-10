//
//  LightRoute.swift
//  LightRoute
//
//  Created by Владислав Прусаков on 10/04/2017.
//  Copyright © 2017 WebAnt. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Public typealiase


/// This block returns the controller type to which could lead.
public typealias TransitionSetupBlock<T> = ((T) -> Void)

/// This block is responsible for return transition data.
public typealias TransitionBlock = ((_ source: UIViewController, _ destination: UIViewController) -> Void)


/// This block is responsible for implementing the transition.
public typealias TransitionPostLinkAction = (() -> Void)

// MARK: -
// MARK: Storyboard factory

/// This protocol a describe that destination controller should be returns.
public protocol StoryboardFactoryProtocol: class {
	
	/// Instantiate transition view controller.
	var instantiateTransitionHandler: UIViewController { get }
}

/// This factory class a performs `StoryboardFactoryProtocol` and the instantiate transition view controller.
public final class StoryboardFactory: StoryboardFactoryProtocol {
	
	// MARK: -
	// MARK: Properties
	
	// MARK: Public
	
	public var instantiateTransitionHandler: UIViewController {
		let controller = self.restorationId.isEmpty ? self.storyboard.instantiateInitialViewController() :
			self.storyboard.instantiateViewController(withIdentifier: self.restorationId)
		
		// If destination controller is nil then return fatal error.
		guard let destination = controller else {
			fatalError("[LightRoute]: View controller with \(self.restorationId) not found!")
		}
		
		return destination
	}
	
	
	// MARK: Private
	
	private(set) var storyboard: UIStoryboard
	private(set) var restorationId: String
	
	
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



// MARK: -
// MARK: Transition handler protocol


/// This protocol describe how transition beetwen view controllers.
public protocol TransitionHandler: class {
	
	///
	/// Method initiates transition handler for action.
	///
	/// - parameter identifier: Identifier of the view controller on the current storyboard.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	/// - returns: Transition promise class with setups.
	///
	func openModuleStoryboard<T>(identifier: String, for type: T.Type) -> TransitionPromise<T>
	
	///
	/// Methods initaites transition for storyboard factory and wait actions.
	///
	/// - parameter factory:
	/// - returns: Custom transition promise class with setups.
	///
	func openModuleStoryboard(factory: StoryboardFactoryProtocol) -> CustomTransitionPromise<UIViewController>
	
	///
	/// Methods initaites transition for storyboard name and cast type and wait actions.
	///
	/// - parameter factory:
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	/// - returns: Custom transition promise class with setups.
	///
	func openModuleStoryboard<T>(factory: StoryboardFactoryProtocol, for type: T.Type) -> CustomTransitionPromise<T>
}


// MARK: -
// MARK: Transition implementation


/// The class is responsible for what the user has implemented the transition.
public final class CustomTransitionPromise<T> {
	
	private var root: UIViewController
	private var destination: UIViewController?
	private var type: T.Type
	
	///
	/// Initialize custom transition promise. This class is responsible for the fact that the user will carry out necessary transition.
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
	/// - returns: Transition promise class with setups.
	///
	public func transition(_ block: @escaping TransitionBlock) -> TransitionPromise<T> {
		
		let promise = TransitionPromise(destination: destination, for: type)
		
		// Need to protect the transition from custom transitions from the outside.
		promise._protected = true
		
		promise.postLintAction {
			block(self.root, self.destination!)
		}
		
		return promise
	}
	
}


/// Establishes liability for the current transition.
public enum TransitionCase {
	
	/// This case performs that current transition must be add to navigation completion stack.
	case navigationController(case: TransitionNavigationCase)
	
	/// This case performs that current transition must be presented from initiated view controller.
	case `default`
}


/// Responds transition case how navigation controller will be add transition on navigation stack.
public enum TransitionNavigationCase {
	
	/// This case performs that current transition must be push.
	case push
	
	/// This case performs that current transition must be popup.
	case popup
	
	/// This case performs that current transition must be present.
	case present
}



/// The main class that describes the current transition.
public final class TransitionPromise<T> {
	
	// MARK: -
	// MARK: Properties
	
	
	// MARK: Public
	
	/// Shows animated this transition or not.
	public var isAnimated: Bool {
		return _isAnimated
	}
	
	/// Check transition protected or not.
	public var isProtected: Bool {
		return _protected
	}
	
	
	// MARK: Private
	
	// Wait transition post action.
	private var postLinkAction: TransitionPostLinkAction?
	
	// Set and get current transition animate state.
	private(set) var _isAnimated: Bool = true
	
	// Set and get current transition flow state.
	internal(set) var _protected: Bool = false
	
	// Main transition data.
	private var destination: UIViewController?
	internal weak var root: UIViewController?
	
	// Save current transition case.
	private var transitionCase: TransitionCase?
	
	
	// MARK: -
	// MARK: Initialize
	
	///
	/// Initialize transition promise for current transition.
	/// - parameter distination: The view controller at which the jump occurs.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	///
	init(destination: UIViewController?, for: T.Type) {
		self.destination = destination
	}
	
	// MARK: -
	// MARK: Public methods
	
	///
	/// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
	///
	/// - parameter block: Initialize controller for transition and fire.
	///
	public func then(_ block: TransitionSetupBlock<T>) {
		if destination != nil && destination is T {
			block((destination as! T))
			
			self.push()
		} else if destination != nil {
			fatalError("[LightRoute]: This type \"\(T.self)\" is not supported view controller")
		} else {
			fatalError("[LightRoute]: Distination view controller will be nil")
		}
	}
	
	
	///
	/// Instantiate transition case and waits, when should be active.
	/// - note: This method must be called once for the current transition.
	/// You can call it many times, but he still fire only the last called function.
	///
	/// - parameter case: Case for transition promise.
	/// - returns: Configured transition promise.
	///
	public func from(case transitionCase: TransitionCase) -> TransitionPromise<T> {
		if self.isProtected {
			print("[LightRoute]: Can't add transition case, as was current transition is protected.")
			
			return self
		}
		// Remove old link action then we can setup new transition action.
		self.postLinkAction = nil
		
		// Setup new transition action from transition case.
		self.postLintAction { [weak self] in
			guard let destination = self?.destination, let root = self?.root, let animated = self?.isAnimated else { fatalError("[LightRoute]: Distination or Root view controllers will be nil") }
			switch transitionCase {
			case .navigationController(case: let navCase):
				
				guard let navController = root.navigationController else {
					print("[LightRoute]: Transition error, navigation controller will be nil.")
					return
				}
				
				switch navCase {
				case .popup:
					navController.popToViewController(destination, animated: animated)
				case .present:
					navController.present(destination, animated: animated, completion: nil)
				case .push:
					navController.pushViewController(destination, animated: animated)
				}
				
			case .default:
				root.present(destination, animated: animated, completion: nil)
			}
		}
		
		return self
	}
	
	
	///
	/// Turn on or off animate for current transition.
	/// - note: By default this transition is animated.
	///
	/// - parameter animate: Animate or not current transition ifneeded.
	///
	public func transition(animate: Bool) -> TransitionPromise<T> {
		self._isAnimated = animate
		
		return self
	}
	
	/// This method makes a current transition.
	public func push() {
		self.postLinkAction?()
	}
	
	// MARK: -
	// MARK: Private methods
	
	///
	/// This method waits to be able to fire.
	/// - parameter completion: Whait push action from `TransitionPromise` class.
	///
	func postLintAction( _ completion: @escaping TransitionPostLinkAction) {
		self.postLinkAction = completion
	}
	
}


// MARK: -
// MARK: Extension UIViewController

public extension TransitionHandler where Self: UIViewController {
	
	func openModuleStoryboard<T>(identifier: String, for type: T.Type) -> TransitionPromise<T> {
		let destination = self.storyboard?.instantiateViewController(withIdentifier: identifier)
		
		let promise = TransitionPromise(destination: destination, for: type)
		promise.root = self
		
		// Default transition action.
		promise.postLintAction {
			self.present(destination!, animated: true, completion: nil)
		}
		
		return promise
	}
	
	func openModuleStoryboard(factory: StoryboardFactoryProtocol) -> CustomTransitionPromise<UIViewController> {
		let destination = factory.instantiateTransitionHandler
		
		let promise = CustomTransitionPromise(root: self, destination: destination, for: UIViewController.self)
		return promise
	}
	
	func openModuleStoryboard<T>(factory: StoryboardFactoryProtocol, for type: T.Type) -> CustomTransitionPromise<T> {
		let destination = factory.instantiateTransitionHandler
		
		let promise = CustomTransitionPromise(root: self, destination: destination, for: type)
		return promise
	}
	
}


/// This extension adds public methods for work with LightRoute.
extension UIViewController: TransitionHandler {}
