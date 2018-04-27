//
//  SocialView.swift
//  iOS Example
//
//  Created by v.a.prusakov on 24/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class SocialView: PressableView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var social: Social!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }
    
    func configure(social: Social) {
        self.imageView.image = social.logo
        self.applyShadow(color: social.color, radius: 10, opacity: 0.4, offset: CGSize(width: 0, height: 4))
        self.nameLabel.text = social.name
        self.social = social
    }
    
    @objc private func tapped() {
        guard let url = self.social.url, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.openURL(url)
    }
}
