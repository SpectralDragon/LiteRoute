//
//  CustomMoreActionViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 23/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class CustomMoreActionViewController: UIViewController, CustomContentMovable {
    
    @IBOutlet private weak var effectView: UIVisualEffectView!
    @IBOutlet private weak var actionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestures()
        self.actionView.applyShadow(color: .black, radius: 10, opacity: 0.15, offset: CGSize(width: 0, height: -5))
    }
    
    // MARK: - Setup
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.effectView.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    // MARK: - CustomContentMovable
    
    var movableView: UIView {
        return self.actionView
    }
}
