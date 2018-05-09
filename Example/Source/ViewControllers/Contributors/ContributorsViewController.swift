//
//  ContributorsViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class ContributorsViewController: UIViewController, DismissSender {
    
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    fileprivate var items: [ContributorModel] = []
    
    weak var dismissListner: DismissObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerCell(ContributorCollectionViewCell.self)
        self.emptyStateView.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func onTryAgainAction() {
        
    }
    
    @IBAction func close() {
        self.dismissListner?.presentedViewDidDismiss()
        self.dismiss(animated: true)
    }
    
}

// MARK: - Private
extension ContributorsViewController {
    
    private func getConributingList() {
        URLSession(configuration: .default).dataTask(with: URL(string: "")!) { data, response, error in
            
        }.resume()
    }
    
}

// MARK: - UICollectionViewDelegate
extension ContributorsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ContributorsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize(collectionView: collectionView, layout: collectionViewLayout)
    }
    
    private func itemSize(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGSize {
        guard let collectionViewFlowLayout = (collectionViewLayout as? UICollectionViewFlowLayout) else { return .zero }
        let itemWidthAndHeight = (collectionView.frame.width / 2) - collectionViewFlowLayout.minimumInteritemSpacing * 2
        
        return CGSize(width: itemWidthAndHeight, height: itemWidthAndHeight)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ContributorsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ContributorCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = ContributorModel(name: "SpectralDragon", url: "github.com/spectraldragon", avatar: #imageLiteral(resourceName: "mountains"))
        (cell as? ContributorCollectionViewCell)?.configure(with: item)
    }
    
}
