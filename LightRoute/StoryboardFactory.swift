//
//  StoryboardFactory.swift
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


/// This factory class a performs `StoryboardFactoryProtocol` and the instantiate transition view controller.
public struct StoryboardFactory: StoryboardFactoryProtocol {
    
    // MARK: -
    // MARK: Properties
    
    // MARK: Public
    /// Instantiate transition view controller.
    public func instantiateTransitionHandler() throws -> UIViewController {
        let controller = self.restorationId.isEmpty ? self.storyboard.instantiateInitialViewController() :
            self.storyboard.instantiateViewController(withIdentifier: self.restorationId)
        
        // If destination controller is nil then return error.
        guard let destination = controller else {
            throw LightRouteError.restorationId(self.restorationId)
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
