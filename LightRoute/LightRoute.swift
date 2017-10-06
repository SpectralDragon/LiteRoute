//
//  LightRoute.swift
//  LightRoute
//
//  Created by Vladislav Prusakov on 10/04/2017.
//  Copyright © 2017 Vladislav Prusakov. All rights reserved.
//


import ObjectiveC.runtime

// MARK: -
// MARK: Public typealiase

/// This block returns the controller type to which could lead.
public typealias TransitionSetupBlock<T> = ((T) -> Any?)

/// This block is responsible for return transition data.
public typealias TransitionBlock = ((_ source: UIViewController, _ destination: UIViewController) -> Void)


/// This block is responsible for implementing the transition.
public typealias TransitionPostLinkAction = (() throws -> Void)

// MARK: -
// MARK: Transition implementation

/// Establishes liability for the current transition.
public enum TransitionStyle {
    
    /// This case performs that current transition must be add to navigation completion stack.
    case navigationController(style: TransitionNavigationStyle)
    
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
}

/// This class is main frame to transition's
public class GenericTransitionNode<T> {
    
    // Main transition data.
    internal unowned var root: UIViewController
    internal var destination: UIViewController?
    internal var type: T.Type
    
    
    // Wait transition post action.
    internal var postLinkAction: TransitionPostLinkAction?
    
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
    
    ///
    /// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
    ///
    /// - parameter block: Initialize controller for transition and fire.
    ///
    open func then(_ block: @escaping TransitionSetupBlock<T>) throws {
        guard let destination = self.destination else { throw LightRouteError.viewControllerWasNil("Destination") }
        
        var moduleInput: Any? = destination.moduleInput
        
        // If first controller was UINavigationController, then try find top view controller.
        if destination is UINavigationController {
            let result = (destination as! UINavigationController).topViewController ?? destination
            moduleInput = result.moduleInput
        }
        
        if moduleInput is T {
            let moduleOutput = block(moduleInput as! T)
            self.destination?.moduleOutput = moduleOutput
            try self.push()
        } else {
            throw LightRouteError.castError(controller: .init(describing: T.self), type: "\(moduleInput as Any)")
        }
        
    }
    
    /// This method makes a current transition.
    public func push() throws {
        try self.postLinkAction?()
    }
    
    // MARK: -
    // MARK: Private methods
    
    ///
    /// This method waits to be able to fire.
    /// - parameter completion: Whait push action from `TransitionPromise` class.
    ///
    func postLinkAction( _ completion: @escaping TransitionPostLinkAction) {
        self.postLinkAction = completion
    }
}

/// The class is responsible for what the user has implemented the transition.
public final class CustomTransitionNode<T> {
    
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
    public func transition(_ block: @escaping TransitionBlock) -> GenericTransitionNode<T> {
        
        let promise = GenericTransitionNode(root: root, destination: destination, for: type)
        
        promise.postLinkAction {
            block(self.root, self.destination!)
        }
        
        return promise
    }
    
}

public final class SegueTransitionNode<T>: GenericTransitionNode<T> {
    var transitioningDelegate: UIViewControllerTransitioningDelegate?
    var segueIdentifier: String = ""
    
    public func add(transitioningDelegate: UIViewControllerTransitioningDelegate) -> SegueTransitionNode<T> {
        self.transitioningDelegate = transitioningDelegate
        return self
    }
    
    public override func then(_ block: @escaping TransitionSetupBlock<T>) throws {
        DispatchQueue.main.async {
            self.root.performSegue(withIdentifier: self.segueIdentifier, sender: nil, completion: { segue in
                var destination = segue.destination
                destination.transitioningDelegate = self.transitioningDelegate
                
                if destination is UINavigationController {
                    destination = (segue.destination as! UINavigationController).topViewController ?? segue.destination
                } else if destination is UITabBarController {
                    let tabBarController = (segue.destination as! UITabBarController)
                    guard let viewControllers = tabBarController.viewControllers else {
                        throw LightRouteError.customError("ViewControllers in UITabBarController can't be nil")
                    }

                    for controller in viewControllers {
                        if controller.moduleInput is T || controller is T {
                            destination = controller
                            break
                        }
                    }
                }

                var output: Any?

                if let moduleInput = destination.moduleInput, moduleInput is T {
                    output = block(destination.moduleInput as! T)
                } else if destination is T {
                    output = block(destination as! T)
                } else {
                    throw LightRouteError.castError(controller: String(describing: destination.self), type: "\(self.type)")
                }

                segue.source.moduleOutput = output
            })
        }
    }
}


/// The main class that describes the current transition.
public final class TransitionNode<T>: GenericTransitionNode<T> {
	
	// MARK: -
	// MARK: Properties
	// MARK: Public
	
	/// Shows animated this transition or not.
	public var isAnimated: Bool {
		return animated
	}
	
	// MARK: Private
	// Set and get current transition animate state.
	internal var animated: Bool = true
	
	// Save current transition case.
	private var transitionCase: TransitionStyle?

	// MARK: -
	// MARK: Public methods
	
	///
	/// Instantiate transition case and waits, when should be active.
	/// - note: This method must be called once for the current transition.
	/// You can call it many times, but he still fire only the last called function.
	///
	/// - parameter case: Case for transition promise.
	/// - returns: Configured transition promise.
	///
	public func to(preferred style: TransitionStyle) throws -> TransitionNode<T> {
		// Remove old link action then we can setup new transition action.
		self.postLinkAction = nil
		
		// Setup new transition action from transition case.
		self.postLinkAction { [weak self] in
            guard let destination = self?.destination else {
                throw LightRouteError.viewControllerWasNil("Destination")
            }
			guard let root = self?.root, let animated = self?.isAnimated else {
				throw LightRouteError.viewControllerWasNil("Root")
			}
            
			switch style {
			case .navigationController(style: let navCase):
				
				guard let navController = root.navigationController else {
					throw LightRouteError.viewControllerWasNil("Transition error, navigation")
				}
				
				switch navCase {
				case .pop:
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
	public func transition(animate: Bool) -> TransitionNode<T> {
		self.animated = animate
		return self
	}
    
    public func add(transitioningDelegate: UIViewControllerTransitioningDelegate) -> TransitionNode<T> {
        self.destination?.transitioningDelegate = transitioningDelegate
        return self
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
	public func customTransition() throws -> CustomTransitionNode<T> {
		guard let destination = destination else { throw LightRouteError.viewControllerWasNil("Destination") }
		
		self.postLinkAction = nil
		let promise = CustomTransitionNode(root: root, destination: destination, for: type)
		return promise
	}
    
}

// MARK: -
// MARK: Extension UIViewController

public extension TransitionHandler where Self: UIViewController {
	
	func forCurrentStoryboard<T>(resterationId: String, to type: T.Type) throws -> TransitionNode<T> {
		guard let storyboard = self.storyboard else { throw LightRouteError.storyboardWasNil }
		
		let destination = storyboard.instantiateViewController(withIdentifier: resterationId)
		
		let node = TransitionNode(root: self, destination: destination, for: type)
		
		// Default transition action.
		node.postLinkAction { [unowned self] in
			self.present(destination, animated: true, completion: nil)
		}
		
		return node
	}
	
	func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) throws -> TransitionNode<T> {
		let destination = try factory.instantiateTransitionHandler()
		
		let node = TransitionNode(root: self, destination: destination, for: type)
		
		// Default transition action.
        node.postLinkAction { [unowned self] in
			self.present(destination, animated: true, completion: nil)
		}
		
		return node
	}
    
    func forSegue<T>(identifier: String, to type: T.Type) -> SegueTransitionNode<T> {
        let node = SegueTransitionNode(root: self, destination: nil, for: type)
        node.segueIdentifier = identifier

        // Default transition action.
        node.postLinkAction {
            try node.then { _ in return nil }
        }
        
        return node
    }
	
    func closeModule(animated: Bool) {
        if let navigationVC = self.navigationController {
            navigationVC.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    func closeModulesInStack(animated: Bool) {
        if let navigationVC = self.navigationController {
            navigationVC.popToRootViewController(animated: animated)
        } else {
            print("[LightRoute]: The navigationController's stack doesn't exist, dissmiss only the top view controller")
            self.dismiss(animated: animated, completion: nil)
        }
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
	
	public var moduleOutput: Any? {
		get {
			let box = objc_getAssociatedObject(self, &UIViewController.TransitionHandlerModuleOutput) as? Box
            return box?.value
		}
		set {
			objc_setAssociatedObject(self, &UIViewController.TransitionHandlerModuleOutput, Box(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
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
	@nonobjc static var TransitionHandlerModuleOutput = "ru.hipsterknight.lightroute.moduleOutput"
	
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
	typealias ConfiguratePerformSegue = (UIStoryboardSegue) throws -> ()
	
	// MARK: Swizzled methods
	func performSegue(withIdentifier identifier: String, sender: Any?, completion: @escaping ConfiguratePerformSegue) {
		swizzlePrepareForSegue()
		configuratePerformSegue = completion
		performSegue(withIdentifier: identifier, sender: sender)
	}
	
	func swizzlePrepareForSegue() {
		
		// Must be fire once time.
		DispatchQueue.once(token: "ru.hipsterknight.lightroute.dispatch.swizzle.prepareForSegue") {
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
        do {
            try configuratePerformSegue?(segue)
            swizzledPrepare(for: segue, sender: sender)
            configuratePerformSegue = nil
        } catch {
            print("Swizzle error", error.localizedDescription)
        }
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
