//
//  SegueTransitionNode.swift
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


public final class SegueTransitionNode<T>: GenericTransitionNode<T> {
	
    /// Contain transition delegate for transition.
	var transitioningDelegate: UIViewControllerTransitioningDelegate?
	
    /// Containt segue identifer, for `prepare(for:sender:)` method.
	var segueIdentifier: String = ""
	
    ///
    /// Apply UIViewControllerTransitioningDelegate for current transition.
    ///
    /// - Parameter transitioningDelegate: UIViewControllerTransitioningDelegate instance.
    /// - Returns: Return current transition node.
    ///
	public func add(transitioningDelegate: UIViewControllerTransitioningDelegate) -> SegueTransitionNode<T> {
		self.transitioningDelegate = transitioningDelegate
		return self
	}

    ///
    /// This method checks if source(root) view controller conforms protocol for embed segues transition.
    ///
    /// - Throws: Throw error, if source(root) view controller doesn't conform `ViewContainerForEmbedSegue` protocol.
    ///
    private func checkForEmbedSegue() throws {
        guard root is ViewContainerForEmbedSegue else {
            throw LightRouteError.customError("Source viewController doesn't conform to `ViewContainerForEmbedSegue` protocol.")
        }
    }
    
    ///
    /// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
    ///
    /// - Parameter async: If true, then segue performs async.
    /// - Parameter block: Initialize controller for transition and fire.
    /// - Throws: Throw error, if destination was nil or could not be cast to type or not conform embed segue protocol.
    ///
	public func then(async: Bool, _ block: @escaping TransitionSetupBlock<T>) throws {

        let thenBody = {
            self.root.performSegue(withIdentifier: self.segueIdentifier, sender: nil, completion: { segue in
                if segue is EmbedSegue { try self.checkForEmbedSegue() }
                
                var destination = segue.destination
                destination.transitioningDelegate = self.transitioningDelegate
                
                if destination is UINavigationController {
                    destination = (segue.destination as! UINavigationController).topViewController ?? segue.destination
                } else if destination is UITabBarController {
                    let tabBarController = (segue.destination as! UITabBarController)
                    guard let viewControllers = tabBarController.viewControllers else {
                        throw LightRouteError.customError("ViewControllers in UITabBarController can't be nil")
                    }
                    
                    if tabBarController.moduleInput is T {
                        destination = tabBarController
                    } else {
                        for controller in viewControllers {
                            let moduleInput = (self.customModuleInput != nil) ? self.customModuleInput : destination.moduleInput
                            if moduleInput is T || controller is T {
                                destination = controller
                                break
                            }
                        }
                    }
                }
                
                var output: Any?
                
                let destinationModuleInput = (self.customModuleInput != nil) ? self.customModuleInput : destination.moduleInput
                if let moduleInput = destinationModuleInput, moduleInput is T {
                    output = block(destination.moduleInput as! T)
                } else if destination is T {
                    output = block(destination as! T)
                } else {
                    throw LightRouteError.castError(controller: String(describing: destination.self), type: "\(self.type)")
                }
                
                segue.source.moduleOutput = output
            })
        }

        if async {
            DispatchQueue.main.async {
                thenBody()
            }
        } else {
            thenBody()
        }
	}

	///
    /// This method is responsible for the delivery of the controller for the subsequent initialization, then there is a transition.
    ///
    /// - Parameter block: Initialize controller for transition and fire.
    /// - Throws: Throw error, if destination was nil or could not be cast to type.
    ///
	public override func then(_ block: @escaping TransitionSetupBlock<T>) throws {
        try then(async: true, block)
    }
}
