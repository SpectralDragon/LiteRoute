//
//  CardDetailViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 21/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class CardDetailViewController: UIViewController, CustomContentMovable, Configurable {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var cardView: UIView!
    private weak var frontCardView: FrontCardView!
    
    private var item: CardModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCard()
        self.setupNavigationBar()
        self.setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationBar()
    }
    
    // MARK: - Configurable
    func configure(with item: CardModel) {
        self.item = item
    }
    
    // MARK: - Setups
    private func setupCard() {
        self.cardView.applyShadow(color: Style.Colors.gray_93, radius: 10, opacity: 0.2, offset: CGSize(width: 0, height: 5))
        let frontCardView = FrontCardView.fromNib()
        frontCardView.configure(with: self.item)
        self.cardView.addSubview(frontCardView)
        frontCardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.cardView = frontCardView
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.setValue(true, forKey: "hidesShadow")
        navigationBar.shadowImage = UIImage()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        self.scrollView.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    // MARK: - CustomContentMovable
    var movableView: UIView {
        return self.scrollView
    }
    
}
