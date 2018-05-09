//
//  DetailPresenter.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import Foundation

class DetailPresenter: DetailModuleInput, DetailViewOutput {
    
    weak var view: DetailViewInput!
    var router: DetailRouterInput!
    
    private var text: String = ""
    
    func configure(text: String) {
        self.text = text
    }
    
    func onViewDidLoad() {
        self.view.setText(self.text)
    }
    
    func onClose() {
        self.router.close(animated: true)
    }
    
}
