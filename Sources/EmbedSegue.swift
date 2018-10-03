//
//  EmbedSegue.swift
//  LightRoute
//
//  Created by Kirill Budevich on 02.04.2018.
//  Copyright © 2016-2018 Vladislav Prusakov <hipsterknights@gmail.com>
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

/// Embed segue for embed views via routing
public class EmbedSegue: UIStoryboardSegue {
    override public func perform() {
        guard let identifier = identifier else { return }
        let parentViewController = source
        let embedViewController = destination

        guard let containerView = (parentViewController as? ViewContainerForEmbedSegue)?.containerViewForSegue(identifier),
            let moduleView = embedViewController.view else {
                return
        }

        parentViewController.addChild(embedViewController)
        containerView.addSubview(moduleView)
        embedViewController.didMove(toParent: parentViewController)

        moduleView.translatesAutoresizingMaskIntoConstraints = false

        let top = NSLayoutConstraint(item: moduleView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let bot = NSLayoutConstraint(item: moduleView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: moduleView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: moduleView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1, constant: 0)

        containerView.addConstraints([top, bot, left, right])
    }
}
