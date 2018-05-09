//
//  MainTableViewCell.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell, Configurable, Reusable, PressStateAnimatable {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPressStateAnimationEnabled = true
        self.containerView.applyShadow(color: Style.Colors.gray_93, radius: 10, opacity: 0.2, offset: CGSize(width: 0, height: 5))
    }
    
    func configure(with item: MainModel) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.titleLabel.textColor = selected ? Style.Colors.gray_103 : Style.Colors.white
        self.descriptionLabel.textColor = selected ? Style.Colors.gray_103 : Style.Colors.white
        self.containerView.backgroundColor = selected ? Style.Colors.pink : Style.Colors.gray_103
    }
    
}
