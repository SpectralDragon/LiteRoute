//
//  TransitionNode.swift
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
	/// Set and get current transition animate state.
	internal var animated: Bool = true
	
	/// Save current transition case.
	private var transitionCase: TransitionStyle?
	
	// MARK: -
	// MARK: Public methods
	
	///
	/// Instantiate transition case and waits, when should be active.
	/// - Note: This method must be called once for the current transition.
	/// You can call it many times, but he still fire only the last called function.
	///
	/// - Parameter case: Case for transition node.
	/// - Returns: Configured transition node.
    /// - Throws: Throw error, if need controller was nil and if controller could not be cast to type
	///
	public func to(preferred style: TransitionStyle) throws -> TransitionNode<T> {
		// Remove old link action then we can setup new transition action.
		self.postLinkAction = nil
		
		try fixDestination(for: style)
		
		// Setup new transition action from transition case.
		self.postLinkAction { [weak self] in
			guard let destination = self?.destination else {
				throw LightRouteError.viewControllerWasNil("Destination")
			}
			guard let root = self?.root, let animated = self?.isAnimated else {
				throw LightRouteError.viewControllerWasNil("Root")
			}
			
			switch style {
			case .navigation(style: let navStyle):
				
				guard let navController = root.navigationController else {
					throw LightRouteError.viewControllerWasNil("Transition error, navigation")
				}
				
				switch navStyle {
				case .pop:
					navController.popToViewController(destination, animated: animated)
				case .present:
					navController.present(destination, animated: animated, completion: nil)
				case .push:
					navController.pushViewController(destination, animated: animated)
				}
			case .split(style: let splitStyle):
				
				guard let splitController = root.splitViewController else {
					throw LightRouteError.viewControllerWasNil("Transition error, navigation")
				}
				
				switch splitStyle {
				case .detail:
					splitController.show(destination, sender: nil)
				case .default:
					splitController.showDetailViewController(destination, sender: nil)
				}

            case .modal(let modalStyle):
                destination.modalTransitionStyle = modalStyle.transition
                destination.modalPresentationStyle = modalStyle.presentation
                root.present(destination, animated: animated, completion: nil)

            case .default:
                root.present(destination, animated: animated, completion: nil)
            }
		}
		
		return self
	}
	
	private func fixDestination(for style: TransitionStyle) throws {
		switch style {
		case .navigation(style: let navStyle):
			guard let destination = self.destination else {
				throw LightRouteError.viewControllerWasNil("Destination")
			}
			
			guard let navController = root.navigationController else {
				throw LightRouteError.viewControllerWasNil("Transition error, navigation")
			}
			
			switch navStyle {
			case .pop:
				
				let first = navController.viewControllers.first { $0.restorationIdentifier == destination.restorationIdentifier }
				guard let result = first else {
					throw LightRouteError.customError("Can't get pop controller in navigation controller stack.")
				}
				self.destination = result
			default:
				break
			}
		default:
			break
		}
	}
	
	///
	/// Turn on or off animate for current transition.
	/// - Note: By default this transition is animated.
	///
    /// - Parameter animate: Animate or not current transition ifneeded.
	///
	public func transition(animate: Bool) -> TransitionNode<T> {
		self.animated = animate
		return self
	}
	
    ///
    /// Apply UIViewControllerTransitioningDelegate for current transition.
    ///
    /// - Parameter transitioningDelegate: UIViewControllerTransitioningDelegate instance.
    /// - Returns: Return current transition node.
    ///
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
	/// - Note: Current method return protected transition!
	///
	/// - Returns: Custom transition node with setups.
    /// - Throws: Throw error, if destination was nil.
	///
	public func customTransition() throws -> CustomTransitionNode<T> {
		guard let destination = destination else { throw LightRouteError.viewControllerWasNil("Destination") }
		
		self.postLinkAction = nil
		let node = CustomTransitionNode(root: root, destination: destination, for: type)
		node.customModuleInput = customModuleInput
		return node
	}
	
	///
	/// This methods is responsible for find selector in destination view controller
	/// for configure.
	///
	/// - Parameter selector: String selector for configure module.
	/// - Returns: Transition node instance with setups.
	///
	public func selector(_ selector: String) -> TransitionNode<T> {
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
	public func selector(_ selector: Selector) -> TransitionNode<T> {
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
	public func selector<Root, Type>(_ keyPath: KeyPath<Root, Type>) -> TransitionNode<T> {
		self.customModuleInput = (destination as? Root)?[keyPath: keyPath]
		return self
	}

}
