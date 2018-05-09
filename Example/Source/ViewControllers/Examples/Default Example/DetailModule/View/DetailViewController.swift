//
//  DetailViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 07/05/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailViewInput {
    
    var output: DetailViewOutput!
    
    /// Use @objc if you want use custom selector instead default
    @objc var customOutput: DetailViewOutput! {
        return self.output
    }
    
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - Initialize
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DetailAssembler.resolve(for: self)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.onViewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    // MARK: - DetailViewInput
    
    func setText(_ text: String) {
        self.textLabel.text = text
    }
    
    // MARK: - Actions
    
    @IBAction private func close() {
        self.output.onClose()
    }
}
