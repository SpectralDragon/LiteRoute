//
//  CardModel.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import Foundation

struct CardModel {
    let cardholder: String
    let cardNumber: String
    let validThru: String
    let bankName: String
}

extension CardModel {
    static var mock: CardModel {
        return CardModel(cardholder: "VLADISLAV PRUSAKOV", cardNumber: "5634 3245 0694 3667", validThru: "09/19", bankName: "Tinkoff Bank")
    }
}
