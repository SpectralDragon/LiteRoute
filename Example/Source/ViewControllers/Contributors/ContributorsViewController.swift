//
//  ContributorsViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class ContributorsViewController: UIViewController {
    
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyStateView.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func onTryAgainAction() {
        
    }
    
}

// MARK: - Private

extension ContributorsViewController {
    
    private func getConributingList() {
        
    }
    
}
