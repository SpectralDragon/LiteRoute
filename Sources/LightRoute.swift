//
//  LightRoute.swift
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

    /// This type is responsible for transition case how modal presentation will be add transition on view.
    public typealias ModalStyle = (transition: UIModalTransitionStyle, presentation: UIModalPresentationStyle)

    // MARK: -
    /// Responds transition case how split controller will be add transition on view.
    public enum SplitStyle {

        /// This case performs that current transition will be show like detail.
        case detail

        /// This case performs that current transition will be show by default.
        case `default`
    }

    /// Responds transition case how navigation controller will be add transition on navigation stack.
    public enum NavigationStyle {

        /// This case performs that current transition must be push.
        case push

        /// This case performs that current transition must be pop.
        case pop

        /// This case performs that current transition must be present.
        case present
    }

    /// This case performs that current transition must be add to navigation completion stack.
    case navigation(style: NavigationStyle)

    /// This case performs that current transition must be add like split presentation.
    case split(style: SplitStyle)

    /// This case performs that current transition must be add to navigation completion stack.
    case modal(style: ModalStyle)

    /// This case performs that current transition must be presented from initiated view controller.
    case `default`
}

// MARK: -
// MARK: Extension UIViewController

public extension TransitionHandler where Self: UIViewController {
	
	/// Implementation for current storyboard transition
	func forCurrentStoryboard<T>(restorationId: String, to type: T.Type) throws -> TransitionNode<T> {
		guard let storyboard = self.storyboard else { throw LightRouteError.storyboardWasNil }
		
		let destination = storyboard.instantiateViewController(withIdentifier: restorationId)
		
		let node = TransitionNode(root: self, destination: destination, for: type)
		
		// Default transition action.
		node.postLinkAction { [unowned self, unowned node] in
			self.present(destination, animated: node.isAnimated, completion: nil)
		}
		
		return node
	}
	
	/// Implementation for storyboard factory
	func forStoryboard<T>(factory: StoryboardFactoryProtocol, to type: T.Type) throws -> TransitionNode<T> {
		let destination = try factory.instantiateTransitionHandler()
		
		let node = TransitionNode(root: self, destination: destination, for: type)
		
		// Default transition action.
		node.postLinkAction { [unowned self, unowned node] in
			self.present(destination, animated: node.isAnimated, completion: nil)
		}
		
		return node
	}
	
	/// Implementation for storyboard factory
	func forSegue<T>(identifier: String, to type: T.Type) -> SegueTransitionNode<T> {
		let node = SegueTransitionNode(root: self, destination: nil, for: type)
		node.segueIdentifier = identifier
		
		// Default transition action.
		node.postLinkAction { [unowned node] in try node.then { _ in return nil } }
		
		return node
	}
	
    /// Close current module.
	func closeCurrentModule() -> CloseTransitionNode {
        let node = CloseTransitionNode(root: self)

        node.postLinkAction { [unowned self, unowned node] in
            if let parent = self.parent, parent is UINavigationController {
                let navigationController = parent as! UINavigationController
                
                if navigationController.children.count > 1 {
                    guard let controller = navigationController.children.dropLast().last else { return }
                    navigationController.popToViewController(controller, animated: node.isAnimated)
                } else {
                    self.dismiss(animated: node.isAnimated, completion: nil)
                }
            } else if self.presentingViewController != nil {
                self.dismiss(animated: node.isAnimated, completion: nil)
            }

        }
        
        return node
	}
	
}
