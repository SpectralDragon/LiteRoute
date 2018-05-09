//
//  EmbedExampleViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit
import LightRoute

final class EmbedExampleViewController: UIViewController, DismissSender, ViewContainerForEmbedSegue {
    
    enum Consts {
        static let embedSegueIdentifier = "embed"
    }
    
    @IBOutlet private weak var containerView: UIView!
    
    weak var dismissListner: DismissObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.applyShadow(color: Style.Colors.gray_93, radius: 10, opacity: 0.2, offset: CGSize(width: 0, height: 5))
        try? self.forSegue(identifier: Consts.embedSegueIdentifier, to: UIViewController.self).perform()
    }
    
    @IBAction private func close() {
        self.dismissListner?.presentedViewDidDismiss()
        self.dismiss(animated: true)
    }
    
    // MARK: - ViewContainerForEmbedSegue
    func containerViewForSegue(_ identifier: String) -> UIView {
        return self.containerView
    }
    
}
