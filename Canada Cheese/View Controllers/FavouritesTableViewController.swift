//
//  FavouritesTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController, TabBarReselectHandling {
    
    var navigationBarOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.topItem?.title = NSLocalizedString("Favourite Cheese", comment: "Favourite cheese view navigation bar title")
        navigationBar.tintColor = .systemRed
        
        navigationBarOffset = navigationBar.frame.height + (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CanadianCheeses.favouriteCheeses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteCheeses = CanadianCheeses.favouriteCheeses
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCheeseCell", for: indexPath) as! FavouriteCheeseCell
        
        let cheese = favouriteCheeses[indexPath.row]
        let locale = Bundle.main.preferredLocalizations.first ?? ""
        // Default to using the English value for the cell labels
        let cheeseName = CheeseDetailViewController.propertyValue(for: NSLocalizedString("Cheese", comment: ""), on: cheese, inLocale: locale)
        let cheeseManufacturer = CheeseDetailViewController.propertyValue(for: NSLocalizedString("Manufacturer", comment: ""), on: cheese, inLocale: locale)
        var cheeseFlavourDesc = CheeseDetailViewController.propertyValue(for: NSLocalizedString("Flavour", comment: ""), on: cheese, inLocale: locale)
        
        // See if the flavour is empty
        // Note: This does not guarantee that cheeseFlavourDesc is non-empty as characteristics could still be empty
        if cheeseFlavourDesc.isEmpty {
            cheeseFlavourDesc = CheeseDetailViewController.propertyValue(for: NSLocalizedString("Characteristics", comment: ""), on: cheese, inLocale: locale)
        }
        
        cell.cheeseName.text = cheeseName
        cell.manufacturer.text = cheeseManufacturer
        cell.flavourDescription.text = cheeseFlavourDesc
        cell.favouriteButton.tintColor = .systemRed
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // load up a cheese detail vc
        let favouriteCheeses = CanadianCheeses.favouriteCheeses
        
        if let vc = storyboard?.instantiateViewController(identifier: "cheeseDetail") as? CheeseDetailViewController {
            vc.selectedCheese = favouriteCheeses[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(style: .destructive, title: NSLocalizedString("Remove", comment: "Remove cheese from favourites button")) { action, view, completionHandler in
            // make sure to remove the cheese from the array of favourites
            // note that because the cell at the given indexPath is defined as favouriteCheeses[indexPath.row] (see cellForRowAt indexPath)
            // we can simply remove the objects at that index
            CanadianCheeses.favouriteCheeses.remove(at: indexPath.row)
            CanadianCheeses.favouriteCheesesIDs.remove(at: indexPath.row)
            UserDefaults.standard.setValue(CanadianCheeses.favouriteCheesesIDs, forKey: "favouriteCheesesIDs")
            
            // remove the cell
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let config = UISwipeActionsConfiguration(actions: [remove])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    // MARK: - Tab bar reselect
    
    func handleReselect() {
        tableView?.setContentOffset(CGPoint(x: 0.0, y: 0 - navigationBarOffset), animated: true)
    }
}
