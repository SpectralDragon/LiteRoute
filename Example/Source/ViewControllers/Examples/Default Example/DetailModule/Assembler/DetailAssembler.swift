//
//  DetailAssembler.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

struct DetailAssembler {
    
    static func resolve(for controller: DetailViewController) {
        
        let router = DetailRouter()
        router.transitionHandler = controller
        
        let presenter = DetailPresenter()
        presenter.view = controller
        presenter.router = router
        
        controller.output = presenter
    }
    
}
