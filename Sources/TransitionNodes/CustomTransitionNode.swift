//
//  CustomTransitionNode.swift
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

/// The class is responsible for what the user has implemented the transition.
public final class CustomTransitionNode<T> {
	
	private unowned var root: UIViewController
	private var destination: UIViewController?
	private var type: T.Type
	
	internal var customModuleInput: Any?
	

	///
    /// Initialize custom transition node. This class is responsible for the fact that the user will carry out necessary transition.
    ///
    /// - Parameters:
    ///   - root: The view controller from which the transition.
    ///   - destination: The view controller at which the jump occurs.
    ///   - type: The argument which checks the specified type and controller type for compatibility, and returns this type in case of success.
    ///
	init(root: UIViewController, destination: UIViewController?, for type: T.Type) {
		self.root = root
		self.destination = destination
		self.type = type
	}
	
	///
	/// This method is responsible for that the user realizes the transition
	/// - Parameter block: User transition implementation.
	/// - Returns: Transition node instance with setups.
	///
	public func transition(_ block: @escaping TransitionBlock) -> GenericTransitionNode<T> {
		let node = GenericTransitionNode(root: root, destination: destination, for: type)
		node.postLinkAction { block(self.root, self.destination!) }
		return node
	}
	
	///
	/// This methods is responsible for find selector in destination view controller
	/// for configure.
	///
	/// - Parameter selector: String selector for configure module.
	/// - Returns: Transition node instance with setups.
	///
	public func selector(_ selector: String) -> CustomTransitionNode<T> {
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
	public func selector(_ selector: Selector) -> CustomTransitionNode<T> {
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
	public func selector<Root, Type>(_ selector: KeyPath<Root, Type>) -> CustomTransitionNode<T> {
		self.customModuleInput = (destination as? Root)?[keyPath: selector]
		return self
	}
}
