//
//  GradientView.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

typealias GradientColors = (baseColor: UIColor, gradientColor: UIColor)

class GradientedView: UIView {
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    // MARK: - Private
    
    private func initialSetup() {
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.gradientLayer.locations = [0, 1]
        self.cornerRadius = 15
    }
    
    // MARK: - Public
    
    func setColors(_ colors: GradientColors) {
        self.gradientLayer.colors = [ colors.baseColor.cgColor, colors.gradientColor.cgColor ]
    }
}

