//
//  SettingsViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2021-07-21.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Settings", comment: "")
        
        let done = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(dismissVC))
        done.tintColor = .systemRed
        self.navigationItem.rightBarButtonItems = [done]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        cell.textLabel?.text = NSLocalizedString("Language selection", comment: "")
        cell.imageView?.image = UIImage(systemName: "globe")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
}
