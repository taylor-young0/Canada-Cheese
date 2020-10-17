//
//  FilterTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-04.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    static var activeFilters = Dictionary<String, Set<String>>()
    static var tempFilters = Dictionary<String, Set<String>>()
    static var filters = [
        0 : ["Manufacturing type": ["Artisan", "Farmstead", "Industrial"]],
        1 : ["Manufacturer province" : ["BC", "AB", "SK", "MB", "ON", "QC", "NL", "NB", "NS", "PE"]],
        2 : ["Organic": ["Organic", "Non-organic"]],
        3 : ["Cheese type": ["Soft Cheese", "Semi-soft Cheese", "Firm Cheese", "Hard Cheese", "Veined Cheese", "Fresh Cheese"]],
        4 : ["Milk type": ["Ewe", "Ewe and Goat", "Goat", "Cow", "Cow and Goat", "Buffalo Cow"]],
        5 : ["Milk treatment": ["Raw Milk", "Pasteurized", "Thermised"]],
        6 : ["Rind type": ["Washed Rind", "Brushed Rind", "No Rind"]]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
        let apply = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(dismissVC))
        self.navigationItem.leftBarButtonItems = [cancel]
        self.navigationItem.rightBarButtonItems = [apply]
        //tableView.register(CheeseFilterCell.self, forCellReuseIdentifier: "filterCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func dismissVC(andApplyFilters apply: Bool) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return FilterViewController.filters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (FilterViewController.filters[section]?.first?.value.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! CheeseFilterCell
        cell.filter.text = FilterViewController.filters[indexPath.section]!.first?.value[indexPath.row]
        cell.accessoryType = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterViewController.filters[section]?.first?.key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CheeseFilterCell
        let currentAccessory = cell.accessoryType
        let selectedFilter = cell.filter.text!
        let sectionTitle = (tableView.headerView(forSection: indexPath.section)?.textLabel?.text)!
        // if the filter is already applied, remove it
        if (currentAccessory == .checkmark) {
            FilterViewController.activeFilters["\(sectionTitle)"]?.remove(selectedFilter)
            //TODO: Reset the allCheeses in AllCheeseTableViewController to allow for more filtering, right now it breaks if you remove all a filter, it should revert to as it was before to allow the next added filters the full cheese set. This breaks because allCheeses is constantly changed, so each time a filter is added the array is smaller than before
            print("removed")
        } else {
            // if the section does not already have a set storing the applied filters we must create an empty set
            if FilterViewController.activeFilters["\(sectionTitle)"] == nil {
                FilterViewController.activeFilters["\(sectionTitle)"] = Set<String>()
            }
            FilterViewController.activeFilters["\(sectionTitle)"]?.insert(selectedFilter)
        }
        for (filter, v) in FilterViewController.activeFilters {
            print(filter)
            for f in v {
                print("\t\(f)")
            }
        }
        // change the cell accessory to be the opposite of what it currently is
        cell.accessoryType = (currentAccessory == .none ? .checkmark : .none)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
