//
//  CustomTransitioningDelegate.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

protocol CustomContentMovable: class {
    var movableView: UIView { get }
}

final class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    enum Direction {
        case up, down
        
        var translationDelta: CGFloat { return self == .up ? 20 : -20 }
    }
    
    private(set) var direction: Direction
    
    init(moveDirection direction: Direction = .down) {
        self.direction = direction
    }
    
    private(set) var isPresented: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension CustomTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    private enum Consts {
        static let animationDuration: TimeInterval = 0.4
    }
    
    private typealias KeyframeAnimationTime = (startTime: TimeInterval, duration: TimeInterval)
    
    private var startedAlpha: CGFloat { return self.isPresented ? 1.0 : 0.0 }
    private var finishedAlpha: CGFloat { return !self.isPresented ? 1.0 : 0.0 }
    
    private var startedMovablePosition: CGAffineTransform { return self.isPresented ? .identity : CGAffineTransform(translationX: 0, y: self.direction.translationDelta) }
    private var finishedMovablePosition: CGAffineTransform { return !self.isPresented ? .identity : CGAffineTransform(translationX: 0, y: self.direction.translationDelta) }
    
    private var blurBlockAnimationTime: KeyframeAnimationTime { return !self.isPresented ? (0, 0.6) : (0, 1) }
    private var contentBlockAnimationTime: KeyframeAnimationTime { return !self.isPresented ? (0.6, 0.4) : (0, 1) }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Consts.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let viewController = transitionContext.viewController(forKey: !self.isPresented ? .to : .from) else { return }
        let view = viewController.view!
        
        let blurredContentMovable = ((viewController as? UINavigationController)?.topViewController as? CustomContentMovable) ?? (viewController as? CustomContentMovable)
        let movableView = blurredContentMovable?.movableView
        transitionContext.containerView.addSubview(view)
        
        view.layer.allowsGroupOpacity = false
        view.alpha = self.startedAlpha
        movableView?.alpha = self.startedAlpha
        movableView?.transform = self.startedMovablePosition
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: self.blurBlockAnimationTime.startTime, relativeDuration: self.blurBlockAnimationTime.duration, animations: {
                view.alpha = self.finishedAlpha
            })
            UIView.addKeyframe(withRelativeStartTime: self.contentBlockAnimationTime.startTime, relativeDuration: self.contentBlockAnimationTime.duration, animations: {
                movableView?.alpha = self.finishedAlpha
                movableView?.transform = self.finishedMovablePosition
            })
        }, completion: { finished in
            if finished {
                self.isPresented = !self.isPresented
                transitionContext.completeTransition(true)
            }
        })
    }
}

