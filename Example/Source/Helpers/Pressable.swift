//
//  Pressable.swift
//  iOS Example
//
//  Created by v.a.prusakov on 12/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol PressStateAnimatable: class {
    var pressStateAnimationMinScale: CGFloat { get }
    var pressStateAnimationDuration: TimeInterval { get }
    var isPressStateAnimationEnabled: Bool { get set }
}

extension PressStateAnimatable where Self: UIView {
    
    var pressStateAnimationMinScale: CGFloat { return 0.95 }
    var pressStateAnimationDuration: TimeInterval { return 0.1 }
    
    fileprivate var highlightRecognizer: TouchHandlerGestureRecognizer? {
        return self.gestureRecognizers?.first { $0 is TouchHandlerGestureRecognizer } as? TouchHandlerGestureRecognizer
    }
    
    var isPressStateAnimationEnabled: Bool {
        get { return self.highlightRecognizer != nil }
        set { newValue ? self.enablePressStateAnimation() : disablePressStateAnimation() }
    }
    
    fileprivate func enablePressStateAnimation() {
        
        let minScale = self.pressStateAnimationMinScale
        let duration = self.pressStateAnimationDuration
        
        guard minScale < 1, minScale >= 0, duration > 0 else { return }
        
        self.disablePressStateAnimation()
        
        let touchUpGesture = TouchHandlerGestureRecognizer { [weak self] (gesture) in
            if gesture.state == .began {
                self?.animatePressStateChange(pressed: true, minScale: minScale, duration: duration)
            }
            if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
                self?.animatePressStateChange(pressed: false, minScale: minScale, duration: duration)
            }
        }
        touchUpGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(touchUpGesture)
    }
    
    fileprivate func animatePressStateChange(pressed: Bool, minScale: CGFloat, duration: TimeInterval) {
        let toValue = pressed ? CATransform3DMakeScale(minScale, minScale, 1) : CATransform3DMakeScale(1, 1, 1)
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        
        if let presentationLayer = layer.presentation() {
            scaleAnimation.fromValue = presentationLayer.transform
            
            // Процент выполнения текущей анимации
            let animationProgress = Double((presentationLayer.transform.m11 - minScale) / (1 - minScale))
            
            // Если вью не нажата, то анимация в обратную сторону
            let durationMultiplier = pressed ? animationProgress : (1 - animationProgress)
            scaleAnimation.duration = duration * durationMultiplier
            
        } else {
            scaleAnimation.fromValue = layer.transform
            scaleAnimation.duration = duration
        }
        
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration
        
        // Remove previous animation, is she executed now
        layer.removeAnimation(forKey: "scale")
        layer.add(scaleAnimation, forKey: "scale")
        layer.transform = toValue
    }
    
    fileprivate func disablePressStateAnimation() {
        if let recognizer = self.highlightRecognizer {
            self.removeGestureRecognizer(recognizer)
        }
    }
}

// MARK: - Gestures

final class TouchHandlerGestureRecognizer: TouchGestureRecognizer {
    
    typealias StateChangeHandler = ((UIGestureRecognizer) -> Void)
    
    private let stateChangeHandler: StateChangeHandler
    
    public required init(stateChangeHandler: @escaping StateChangeHandler) {
        self.stateChangeHandler = stateChangeHandler
        super.init()
        self.addTarget(self, action: #selector(handleStateChange(_:)))
    }
    
    // MARK: - Handler
    
    @objc private func handleStateChange(_ gestureRecognizer: UIGestureRecognizer) {
        self.stateChangeHandler(gestureRecognizer)
    }
    
}

class TouchGestureRecognizer: UIGestureRecognizer {
    
    init() {
        super.init(target: nil, action: nil)
    }
    
    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard let view = view, let point = Array(touches).last?.location(in: view) else {
            return
        }
        
        if view.bounds.contains(point) {
            self.state = .possible
        } else {
            self.state = .ended
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
}
