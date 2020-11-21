//
//  FavouritesTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.topItem?.title = "Favourite Cheeses"
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
        // Default to using the English value for the cell labels
        var cheeseName = favouriteCheeses[indexPath.row].CheeseNameEn
        var cheeseManufacturer = favouriteCheeses[indexPath.row].ManufacturerNameEn
        var cheeseFlavourDesc = favouriteCheeses[indexPath.row].FlavourEn
        
        // If the English name is empty check for the French
        // Note: cheeseName could still be empty after this if the French version is also empty
        if cheeseName.isEmpty {
            cheeseName = favouriteCheeses[indexPath.row].CheeseNameFr
        }
        // See if the English manufacturer is empty, if so try the French
        // Note: This does not guarantee that cheeseManufacturer is non-empty
        if cheeseManufacturer.isEmpty {
            cheeseManufacturer = favouriteCheeses[indexPath.row].ManufacturerNameFr
        }
        // See if the English flavour is empty
        // Note: This does not guarantee that cheeseFlavourDesc is non-empty
        if cheeseFlavourDesc.isEmpty {
            cheeseFlavourDesc = favouriteCheeses[indexPath.row].CharacteristicsEn
        }
        
        cell.cheeseName.text = cheeseName
        cell.manufacturer.text = cheeseManufacturer
        cell.flavourDescription.text = cheeseFlavourDesc
        cell.favouriteButton.tintColor = .systemYellow
        
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(style: .destructive, title: "Remove") { action, view, completionHandler in
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
}
