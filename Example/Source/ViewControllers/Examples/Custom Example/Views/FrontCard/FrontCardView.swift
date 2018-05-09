//
//  FrontCardView.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class FrontCardView: UIView, NibInitializable, Configurable {
    
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cardHolderLabel: UILabel!
    @IBOutlet private weak var bankNameLabel: UILabel!
    
    func configure(with item: CardModel) {
        self.cardHolderLabel.text = item.cardholder
        self.dateLabel.text = item.validThru
        self.bankNameLabel.text = item.bankName
        self.cardNumberLabel.text = item.cardNumber
    }
    
}
