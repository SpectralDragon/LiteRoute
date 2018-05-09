//
//  NavigationDetailViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class NavigationDetailViewController: UIViewController, Configurable {
    
    var item: NavigationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if case .present = item.type {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close"), style: .done, target: self, action: #selector(close))
        }
        
        self.navigationItem.title = item.title
    }
    
    
    // MARK: Configurable
    func configure(with item: NavigationModel) {
        self.item = item
    }
    
    // MARK: - Actions
    @objc private func close() {
        try? self.closeCurrentModule().perform()
    }
    
}
