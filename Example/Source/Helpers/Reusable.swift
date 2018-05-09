//
//  Reusable.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

protocol Cell {}

extension UITableViewCell: Cell {}
extension UICollectionViewCell: Cell {}


protocol Reusable: class  {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension Reusable where Self: Cell {
    static var reuseIdentifier: String {
        return String(describing: self) + "Identifier"
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        let nib = UINib(nibName: self.nibName, bundle: Bundle.main)
        return nib
    }
}

extension UITableView {
    func registerCell<T: Reusable & UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UICollectionView {
    func registerCell<T: Reusable & UICollectionViewCell>(_ cellType: T.Type) {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
