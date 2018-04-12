//
//  MainTableViewCell.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell, Configurable, Reusable, PressStateAnimatable {
    
    @IBOutlet private weak var gradientView: GradientedView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPressStateAnimationEnabled = true
    }
    
    func configure(with item: ExampleModel) {
        let colors = item.colors
        self.gradientView.applyShadow(color: colors.gradientColor, radius: 10, opacity: 0.2, offset: CGSize(width: 0, height: 5))
        self.gradientView.setColors(colors)
        
        self.titleLabel.text = item.title
        self.titleLabel.textColor = colors.gradientColor.readableTextColor
        
        self.descriptionLabel.text = item.description
        self.descriptionLabel.textColor = colors.gradientColor.readableTextColor
    }
    
}
