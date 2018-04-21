//
//  NavigationCollectionViewCell.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class NavigationCollectionViewCell: UICollectionViewCell, Reusable, Configurable, PressStateAnimatable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPressStateAnimationEnabled = true
        self.containerView.applyShadow(color: Style.Colors.gray_93, radius: 10, opacity: 0.2, offset: CGSize(width: 0, height: 5))
    }
    
    func configure(with item: NavigationModel) {
        self.titleLabel.text = item.title
    }

}
