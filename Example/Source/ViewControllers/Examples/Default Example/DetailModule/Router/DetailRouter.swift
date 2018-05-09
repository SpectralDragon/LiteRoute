//
//  DetailRouter.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import LightRoute

class DetailRouter: DetailRouterInput {
    
    weak var transitionHandler: TransitionHandler!
    
    func close(animated: Bool) {
        try? self.transitionHandler.closeCurrentModule().transition(animate: animated).perform()
    }
    
}
