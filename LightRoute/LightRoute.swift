//
//  LightRoute.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 10/04/2017.
//  Copyright © 2017 WebAnt. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

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
	
	// Instantiate transition view controller.
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



// MARK: -
// MARK: Transition handler protocol

/// This protocol describe how transition beetwen view controllers.
public protocol TransitionHandler: class {
	
	///
	/// The method of initiating the transition in the current storyboard, which depends on the root view controller.
	///
	/// - parameter identifier: Identifier of the view controller on the current storyboard.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	/// - returns: Transition promise class with setups.
	///
	func forCurrentStoryboard<T>(resterationId: String, to type: T.Type) -> TransitionPromise<T>
	
	///
	/// Methods initaites transition for storyboard name and cast type and wait actions.
	///
	/// - parameter factory: StoryboardFactory inctance.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	/// - returns: Transition promise class with setups.
	///
	func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) -> TransitionPromise<T>
	
	
	///
	/// Methods initiates transition from segue identifier and return transition block.
	///
	/// - parameter identifier: Segue identifier for transition.
	/// - parameter type: Try cast destination controller to your type.
	/// - parameter completion: transition setup block with custon type.
	///
	func forSegue<T>(identifier: String, to type: T.Type, completion: @escaping TransitionSetupBlock<T>)
    
    
    ///
    /// Methods close current module(s).
    ///
    /// - no parameter.
    ///
    func close() -> CloseTransitionPromise
}


// MARK: -
// MARK: Transition implementation


/// The class is responsible for what the user has implemented the transition.
public final class CustomTransitionPromise<T> {
	
	private unowned var root: UIViewController
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
		
		let promise = TransitionPromise(root: self.root, destination: destination, for: type)
		
		// Need to protect the transition from custom transitions from the outside.
		promise.protected = true
		
		promise.postLintAction {
			block(self.root, self.destination!)
		}
		
		return promise
	}
	
}


/// Establishes liability for the current transition.
public enum TransitionStyle {
	
	/// This case performs that current transition must be add to navigation completion stack.
	case navigationController(preferredStyle: TransitionNavigationStyle)
	
	/// This case performs that current transition must be presented from initiated view controller.
	case `default`
}


/// Responds transition case how navigation controller will be add transition on navigation stack.
public enum TransitionNavigationStyle {
	
	/// This case performs that current transition must be push.
	case push
	
	/// This case performs that current transition must be pop.
	case pop
	
	/// This case performs that current transition must be present.
	case present
    
    /// This case performs that current transition must be pop to root.
    case popToRoot
}



/// The main class that describes the current transition.
public final class TransitionPromise<T> {
	
	// MARK: -
	// MARK: Properties
	
	
	// MARK: Public
	
	/// Shows animated this transition or not.
	public var isAnimated: Bool {
		return animated
	}
	
	/// Check transition protected or not.
	public var isProtected: Bool {
		return protected
	}
	
	
	// MARK: Private
	
	// Wait transition post action.
	private var postLinkAction: TransitionPostLinkAction?
	
	// Set and get current transition animate state.
	internal var animated: Bool = true
	
	// Set and get current transition flow state.
	internal var protected: Bool = false
	
	// Main transition data.
	private unowned var root: UIViewController
	private var destination: UIViewController?
	private var type: T.Type
	
	// Save current transition case.
	private var transitionCase: TransitionStyle?
	
	
	// MARK: -
	// MARK: Initialize
	
	///
	/// Initialize transition promise for current transition.
	/// - parameter distination: The view controller at which the jump occurs.
	/// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
	///
	init(root: UIViewController, destination: UIViewController?, for type: T.Type) {
		self.root = root
		self.destination = destination
		self.type = type
	}

	// MARK: -
	// MARK: Public methods
	
	///
	/// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
	///
	/// - parameter block: Initialize controller for transition and fire.
	///
	public func then(_ block: TransitionSetupBlock<T>) {
		guard let destination = self.destination else { fatalError("[LightRoute]: Distination view controller was nil") }
		
		var moduleInput: Any? = destination.moduleInput
		
		// If first controller was UINavigationController, then try find top view controller.
		if destination is UINavigationController {
			let result = (destination as! UINavigationController).topViewController ?? destination
			moduleInput = result.moduleInput
		}
		
		if moduleInput is T {
			block((moduleInput as! T))
			
			self.push()
		} else {
			fatalError("[LightRoute]: Can't cast type \"\(T.self)\" to \(moduleInput as Any) object")
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
	public func to(preferred style: TransitionStyle) -> TransitionPromise<T> {
		if self.isProtected {
			print("[LightRoute]: Can't add transition case, as was current transition is protected.")
			
			return self
		}
		// Remove old link action then we can setup new transition action.
		self.postLinkAction = nil
    
        self.checkForPop(in: style)
		
		// Setup new transition action from transition case.
		self.postLintAction { [weak self] in
			guard let destination = self?.destination, let root = self?.root, let animated = self?.isAnimated else { fatalError("[LightRoute]: Distination or Root view controllers was nil") }
			switch style {
			case .navigationController(preferredStyle: let navCase):
				
				guard let navController = root.navigationController else {
					print("[LightRoute]: Transition error, navigation controller was nil.")
					return
				}
                
				switch navCase {
				case .pop:
					navController.popToViewController(destination, animated: animated)
                case .popToRoot:
                    navController.popToRootViewController(animated: animated)
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
		self.animated = animate
		return self
	}
	
	/// This method makes a current transition.
	public func push() {
		self.postLinkAction?()
	}
	
	
	///
	/// Make custom transition from current transition.
	///
	/// Custom transition return source and destination view controllers, that you can setup him and set custom transition way.
	///
	/// For this case you can't change transition from TransitionPromise methods, since they will be marked as protected transition.
	///
	/// - note: Current method return protected transition!
	///
	/// - returns: Custom transition promise with setups.
	///
	public func customTransition() -> CustomTransitionPromise<T> {
		guard !isProtected else { fatalError("[LightRoute]: Can't complete custom transition") }
		guard let destination = destination else { fatalError("[LightRoute]: Controllers was nil") }
		
		self.postLinkAction = nil
		let promise = CustomTransitionPromise(root: root, destination: destination, for: type)
		return promise
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
    
    ///
    /// This method check style for 'pop', if so then change destination view controller to correct from navigation stack.
    /// - parameter style: Style from `TransitionStyle` class.
    ///
    private func checkForPop(in style: TransitionStyle) {
        switch style {
        case .navigationController(preferredStyle: let navStyle):
            switch navStyle {
            case .pop:
                guard let dest = self.getDestinationFromNavigationStack() else { fatalError("[LightRoute]: Destination view controller was nil (not exist in navigation stack)") }
                destination = dest
            default:
                break
            }
            
        default:
            break
        }
    }
    
    ///
    /// This method found correct view controller from navigation stack.
    /// - no parameter.
    ///
    private func getDestinationFromNavigationStack() -> UIViewController? {
        guard let navController = root.navigationController else {
            print("[LightRoute]: Transition error, navigation controller was nil.")
            return nil
        }
        let destinationId = destination?.restorationIdentifier
        
        return navController.viewControllers.filter({ $0.restorationIdentifier == destinationId}).first
    }
}


/// The main class that describes the closing transition.
public final class CloseTransitionPromise {
    
    // MARK: -
    // MARK: Properties
    
    
    // MARK: Public
    
    /// Shows animated this transition or not.
    public var isAnimated: Bool {
        return animated
    }
    
    /// Check transition protected or not.
    public var isProtected: Bool {
        return protected
    }
    
    
    // MARK: Private
    
    // Wait transition post action.
    private var postLinkAction: TransitionPostLinkAction?
    
    // Set and get current transition animate state.
    internal var animated: Bool = true
    
    // Set and get current transition flow state.
    internal var protected: Bool = false
    
    // Main transition data.
    private unowned var root: UIViewController
    
    // Save current transition case.
    private var transitionCase: TransitionStyle?
    
    
    // MARK: -
    // MARK: Initialize
    
    ///
    /// Initialize transition promise for current transition.
    /// - parameter distination: The view controller at which the jump occurs.
    /// - parameter type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    ///
    init(root: UIViewController) {
        self.root = root
    }
    
    /// This method makes a current transition.
    public func pop() {
        self.postLinkAction?()
    }
    
    ///
    /// Instantiate transition case and waits, when should be active.
    /// - note: This method must be called once for the current transition.
    /// You can call it many times, but he still fire only the last called function.
    ///
    /// - parameter case: Case for transition promise.
    /// - returns: Configured transition promise.
    ///
    public func to(preferred style: TransitionStyle) -> CloseTransitionPromise {
        if self.isProtected {
            print("[LightRoute]: Can't add transition case, as was current transition is protected.")
            
            return self
        }
        // Remove old link action then we can setup new transition action.
        self.postLinkAction = nil
        
        // Setup new transition action from transition case.
        self.postLintAction { [weak self] in
            guard let root = self?.root, let animated = self?.isAnimated else { fatalError("[LightRoute]: Root view controller was nil") }
            
            switch style {
            case .navigationController(preferredStyle: let navCase):
                
                guard let navController = root.navigationController else {
                    print("[LightRoute]: Transition error, navigation controller was nil.")
                    return
                }
                
                switch navCase {
                case .popToRoot:
                    navController.popToRootViewController(animated: animated)
                default:
                    fatalError("[LightRoute]: Use only popToRoot in this case")
                }
        
            case .default:
                if let navController = root.navigationController {
                    navController.popViewController(animated: animated)
                } else {
                    root.dismiss(animated: animated, completion: nil)
                }
            }
        }
        
        return self
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
	
	
	func forCurrentStoryboard<T>(resterationId: String, to type: T.Type) -> TransitionPromise<T> {
		guard let storyboard = self.storyboard else { fatalError("[LightRoute]: Storyboard was nil") }
		
		let destination = storyboard.instantiateViewController(withIdentifier: resterationId)
		
		let promise = TransitionPromise(root: self, destination: destination, for: type)
		
		// Default transition action.
		promise.postLintAction {
			self.present(destination, animated: true, completion: nil)
		}
		
		return promise
	}
	
	
	func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) -> TransitionPromise<T> {
		let destination = factory.instantiateTransitionHandler
		
		let promise = TransitionPromise(root: self, destination: destination, for: type)
		
		// Default transition action.
		promise.postLintAction {
			self.present(destination, animated: true, completion: nil)
		}
		
		return promise
	}
	
	
	func forSegue<T>(identifier: String, to type: T.Type, completion: @escaping TransitionSetupBlock<T>) {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: identifier, sender: nil) { segue in
				var destination = segue.destination
				
				guard destination.moduleInput is T else { fatalError("[LightRoute]: Can't bring controller \(String(describing: destination.self)) to type \(type)") }
				
				if destination is UINavigationController {
					destination = (segue.destination as! UINavigationController).topViewController ?? segue.destination
				}
				
				completion(destination.moduleInput as! T)
			}
		}
	}
    
    
    func close() -> CloseTransitionPromise {
        let promise = CloseTransitionPromise(root: self)
        
        // Default close transition action.
        promise.postLintAction {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        return promise
    }
}

///
/// This extension adds public methods for work with LightRoute.
/// Performs swizzle default `prepare(for:sender:)` method and return transition segue.
///
extension UIViewController: TransitionHandler {
	
	/// This property return tradition VIPER presenter object from "output" property.
	var moduleInput: Any? {
		let reflection = Mirror(reflecting: self).children
		var output: Any?
		
		// Find `output` property
		for property in reflection {
			if property.label! == "output" {
				output = property.value
				break
			}
		}
		
		return output
	}
	
	///
	/// You can read more about this implemetation in this article - ["Swift improve performSegue(withIdentifier:sender:) or a router with storyboards"](https://habrahabr.ru/post/275783/)
	///
	
	// Wrapper for save objects with nil.
	class Box {
		let value: Any?
		init(_ value: Any?) {
			self.value = value
		}
	}
	
	// Key for objc associated objects.
	@nonobjc static var ClosurePrepareForSegueKey = "ru.hipsterknight.lightroute.prepareForSegue"
	
	// Contain information about current transition segue.
	var configuratePerformSegue: ConfiguratePerformSegue? {
		get {
			let box = objc_getAssociatedObject(self, &UIViewController.ClosurePrepareForSegueKey) as? Box
			return box?.value as? ConfiguratePerformSegue
		}
		set {
			objc_setAssociatedObject(self, &UIViewController.ClosurePrepareForSegueKey, Box(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}

	// Return transition segue.
	typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
	
	
	// MARK: Swizzled methods
	
	func performSegue(withIdentifier identifier: String, sender: Any?, completion: @escaping ConfiguratePerformSegue) {
		swizzlePrepareForSegue()
		configuratePerformSegue = completion
		performSegue(withIdentifier: identifier, sender: sender)
	}
	
	func swizzlePrepareForSegue() {
		
		// Must be fire once time.
		DispatchQueue.once(token: "ru.hipsterknight.lightroute.dispatch.swizzle") {
			let originalSelector = #selector(UIViewController.prepare(for:sender:))
			let swizzledSelector = #selector(UIViewController.swizzledPrepare(for:sender:))
			
			let instanceClass = UIViewController.self
			let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
			let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
			
			let didAddMethod = class_addMethod(instanceClass, originalSelector,
			                                   method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
			
			if didAddMethod {
				class_replaceMethod(instanceClass, swizzledSelector,
				                    method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
			} else {
				method_exchangeImplementations(originalMethod, swizzledMethod)
			}
		}
	}
	
	func swizzledPrepare(for segue: UIStoryboardSegue, sender: Any?) {
		configuratePerformSegue?(segue)
		swizzledPrepare(for: segue, sender: sender)
		configuratePerformSegue = nil
	}
	
}


// MARK: - 
// MARK: Dispatch once implemetation.

// Read more: [Dispatch once in Swift 3](http://stackoverflow.com/a/38311178)
fileprivate extension DispatchQueue {
	
	private static var _onceTracker: [String] = []
	
	/// Return default dispatch_once in Swift.
	static func once(token: String, block: () -> Void) {
		objc_sync_enter(self)
		defer { objc_sync_exit(self) }
		
		if _onceTracker.contains(token) {
			return
		}
		
		_onceTracker.append(token)
		block()
	}
}
