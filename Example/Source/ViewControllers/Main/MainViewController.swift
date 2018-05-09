//
//  MainViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 10/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit
import LightRoute

protocol DismissSender: class {
    var dismissListner: DismissObserver? { get set }
}

protocol DismissObserver: class {
    func presentedViewDidDismiss()
}

class MainViewController: UIViewController, DismissObserver {
    
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var items: [MainModel] = .examples

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Fix little bug with table cell labels
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    func setupTableView() {
        self.tableView.estimatedRowHeight = 150
        self.tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerCell(MainTableViewCell.self)
    }
    
    // MARK: - DismissObserver
    func presentedViewDidDismiss() {
        guard let selectedIndex = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: selectedIndex, animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indentifier = self.items[indexPath.row].transitionId
        try? self.forSegue(identifier: indentifier, to: UIViewController.self).then { controller in
            (controller as? DismissSender)?.dismissListner = self
            return nil
        }
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MainTableViewCell).configure(with: self.items[indexPath.row])
    }
    
}
