//
//  ContributorCollectionViewCell.swift
//  iOS Example
//
//  Created by v.a.prusakov on 24/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class ContributorCollectionViewCell: UICollectionViewCell, Reusable, Configurable, PressStateAnimatable {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var profileLinkLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isPressStateAnimationEnabled = true
    }
    
    func configure(with item: ContributorModel) {
        self.avatarImageView.image = item.avatar
        self.nameLabel.text = item.name
        self.profileLinkLabel.text = item.url
    }
}
