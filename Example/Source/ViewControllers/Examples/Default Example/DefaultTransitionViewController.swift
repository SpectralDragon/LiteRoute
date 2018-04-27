//
//  DefaultTransitionViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 23/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class DefaultTransitionViewController: UIViewController, DismissSender {
    
    weak var dismissListner: DismissObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func close() {
        self.dismissListner?.presentedViewDidDismiss()
        self.dismiss(animated: true)
    }
    
}
