//
//  AboutViewController.swift
//  iOS Example
//
//  Created by v.a.prusakov on 23/04/2018.
//  Copyright © 2018 v.a.prusakov. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController, DismissObserver {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var footerSocialView: UIView!
    fileprivate var items: [MainModel] = .about
    
    @IBOutlet private var twitterSocial: SocialView!
    @IBOutlet private var githubSocial: SocialView!
    @IBOutlet private var mediumSocial: SocialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupSocial()
        self.tableView.tableFooterView = self.footerSocialView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Fix little bug with table cell labels
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK: - Setup
    
    func setupSocial() {
        self.twitterSocial.configure(social: .twitter)
        self.githubSocial.configure(social: .github)
        self.mediumSocial.configure(social: .medium)
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
extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indentifier = self.items[indexPath.row].transitionId
        try? self.forSegue(identifier: indentifier, to: UIViewController.self).then { controller in
            (controller as? DismissSender)?.dismissListner = self
            return nil
        }
    }
    
}

// MARK: - UITableViewDataSource
extension AboutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        (cell as? MainTableViewCell)?.configure(with: item)
    }
    
}
