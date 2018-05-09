//
//  DefaultTransitionViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 23/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit
import LightRoute

class DefaultTransitionViewController: UIViewController, DismissSender {
    
    enum Const {
        static let uniqueIdentifier = "detail"
    }
    
    weak var dismissListner: DismissObserver?
    
    private var action: DefaultModel = .current
    private var moduleInputCases: ModuleInputCases = .default
    private var animated: Bool = true
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var yourTextLabel: UILabel!
    @IBOutlet private weak var openForSegmentControl: UISegmentedControl!
    @IBOutlet private weak var moduleInputSegmentControl: UISegmentedControl!
    @IBOutlet private weak var animatedSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        
        self.yourTextLabel.text = "Your Text"
    }
    
    // MARK: - Actions
    
    @IBAction func close() {
        self.dismissListner?.presentedViewDidDismiss()
        self.dismiss(animated: true)
    }
    
    @IBAction func segmentControllDidChange(_ sender: UISegmentedControl) {
        switch sender {
        case self.openForSegmentControl:
            self.action = .init(sender.selectedSegmentIndex)
            self.updateViews()
        case self.moduleInputSegmentControl:
            self.moduleInputCases = .init(sender.selectedSegmentIndex)
        case self.animatedSegmentControl:
            self.animated = !NSNumber(integerLiteral: sender.selectedSegmentIndex).boolValue
        default: return
        }
    }
    
    @IBAction func performTransition(_ sender: UIButton) {
        
        let text = self.yourTextLabel.text ?? ""
        
        switch self.action {
        case .current:
            try? self.forCurrentStoryboard(restorationId: Const.uniqueIdentifier, to: DetailModuleInput.self)
                .transition(animate: self.animated)
                .selectorIfNeeded(for: self.moduleInputCases)
                .then { $0.configure(text: text) }
        case .factory:
            let factory = StoryboardFactory(storyboard: self.storyboard!, restorationId: Const.uniqueIdentifier)
            try? self.forStoryboard(factory: factory, to: DetailModuleInput.self)
                .transition(animate: self.animated)
                .selectorIfNeeded(for: self.moduleInputCases)
                .then {  $0.configure(text: text) }
        case .segue:
            try? self.forSegue(identifier: Const.uniqueIdentifier, to: DetailModuleInput.self).then { $0.configure(text: text) }
        }
    }
    
    @IBAction private func composeAction() {
        let alertController = UIAlertController(title: "Input your text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = self.yourTextLabel.text
        }
        
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(.init(title: "Ok", style: .default, handler: { _ in
            self.yourTextLabel.text = alertController.textFields?.first?.text
        }))
        self.present(alertController, animated: true)
    }
    
    // MARK: - Private
    
    private func updateViews() {
        self.infoLabel.text = self.action.description
        self.animatedSegmentControl.isEnabled = (self.action != .segue)
    }
}

fileprivate extension TransitionNode {
    
    func selectorIfNeeded(for sender: ModuleInputCases) -> TransitionNode<T> {
        switch sender {
        case .default:
            return self
        case .keyPath:
            return self.selector(\DetailViewController.customOutput)
        case .selector:
            return self.selector(#selector(getter: DetailViewController.customOutput))
        }
    }
    
}
