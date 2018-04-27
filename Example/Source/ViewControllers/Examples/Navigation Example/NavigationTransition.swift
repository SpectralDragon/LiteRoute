//
//  NavigationTransition.swift
//  iOS Example
//
//  Created by v.a.prusakov on 17/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit
import LightRoute

final class NavigationTransition: UIViewController, DismissSender {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    enum Consts {
        static let standartInset: CGFloat = 16
    }
    
    weak var dismissListner: DismissObserver?
    
    fileprivate var items: [NavigationModel] = .mock
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerCell(NavigationCollectionViewCell.self)
    }
    
    @IBAction private func close() {
        self.dismissListner?.presentedViewDidDismiss()
        self.dismiss(animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension NavigationTransition: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        try! self.forCurrentStoryboard(restorationId: item.transitionIdentifier, to: NavigationDetailViewController.self)
            .to(preferred: .navigation(style: item.type))
            .then { $0.configure(with: item) }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NavigationTransition: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(collectionView: collectionView, layout: collectionViewLayout)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalItemHeight = self.itemSize(collectionView: collectionView, layout: collectionViewLayout).height * CGFloat(collectionView.numberOfItems(inSection: section) / 2)
        let topInset = (collectionView.frame.height - totalItemHeight) / 2 - self.topLayoutGuide.length
        
        return UIEdgeInsets(top: topInset, left: Consts.standartInset, bottom: 0, right: Consts.standartInset)
    }
    
    private func itemSize(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGSize {
        guard let collectionViewFlowLayout = (collectionViewLayout as? UICollectionViewFlowLayout) else { return .zero }
        let itemWidthAndHeight = (collectionView.frame.width / 2) - collectionViewFlowLayout.minimumInteritemSpacing * 2
        
        return CGSize(width: itemWidthAndHeight, height: itemWidthAndHeight)
    }
    
}

// MARK: - UICollectionViewDataSource
extension NavigationTransition: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? NavigationCollectionViewCell)?.configure(with: self.items[indexPath.row])
    }
    
}
