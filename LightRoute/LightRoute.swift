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
	
	case splitController(style: TransitionSplitStyle)
	
	/// This case performs that current transition must be presented from initiated view controller.
	case `default`
}

/// Responds transition case how split controller will be add transition on view.
public enum TransitionSplitStyle {
	
	/// This case performs that current transition will be show like detail.
	case detail
	
	/// This case performs that current transition will be show by default.
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


// MARK: -
// MARK: Extension UIViewController

public extension TransitionHandler where Self: UIViewController {
	
	/// Implementation for current storyboard transition
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
	
	/// Implementation for storyboard factory
	func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) throws -> TransitionNode<T> {
		let destination = try factory.instantiateTransitionHandler()
		
		let node = TransitionNode(root: self, destination: destination, for: type)
		
		// Default transition action.
		node.postLinkAction { [unowned self] in
			self.present(destination, animated: true, completion: nil)
		}
		
		return node
	}
	
	/// Implementation for storyboard factory
	func forSegue<T>(identifier: String, to type: T.Type) -> SegueTransitionNode<T> {
		let node = SegueTransitionNode(root: self, destination: nil, for: type)
		node.segueIdentifier = identifier
		
		// Default transition action.
		node.postLinkAction { try node.then { _ in return nil } }
		
		return node
	}
	
	func closeCurrentModule(animated: Bool) {
		if let parent = self.parent, parent is UINavigationController {
			let navigationController = parent as! UINavigationController
			
			if navigationController.childViewControllers.count > 1 {
				guard let controller = navigationController.childViewControllers.dropLast().last else { return }
				navigationController.popToViewController(controller, animated: animated)
			}
		} else if self.presentingViewController != nil {
			self.dismiss(animated: animated, completion: nil)
		}
	}
	
}
