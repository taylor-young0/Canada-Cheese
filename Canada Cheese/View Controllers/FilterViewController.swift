//
//  FilterTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-04.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    // cells that were selected in the current viewing of the vc, used to apply filter
    var recentlySelectedCells = Set<CheeseFilterCell>()
    var allCheeseVC: AllCheeseTableViewController?
    // filters that have been selected, but have not yet been applied because the "apply" button has yet to be pressed
    var tempFilters = Dictionary<String, Set<String>>()
    // filters that are currently active
    static var activeFilters = Dictionary<String, Set<String>>()
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
        
        // cancel button to disregard recently selected filters and go back to the main app screen
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissAndCancel))
        // apply button to apply filters and go back to main app screen
        let apply = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(dismissAndApply))
        
        self.navigationItem.leftBarButtonItems = [cancel]
        self.navigationItem.title = "Filter"
        self.navigationItem.rightBarButtonItems = [apply]
    }
    
    @objc func dismissAndCancel() {
        // Toggle the cell accessory as we actually don't want to apply these filters
        // Otherwise it will give the user the visual impression that a filter is (or isn't) applied when it really isn't (or is)
        for filterCell in recentlySelectedCells {
            let currAccessory = filterCell.accessoryType
            filterCell.accessoryType = (currAccessory == .none ? .checkmark : .none)
        }
        // Since the filter VC is about to be dismissed there are no longer any recently selected cells in the current viewing of the filter VC
        recentlySelectedCells.removeAll()
        
        dismiss(animated: true, completion: {self.allCheeseVC!.viewDidAppear(true)})
    }
    
    @objc func dismissAndApply() {
        FilterViewController.activeFilters = tempFilters
        // Since the filter VC is about to be dismissed there are no longer any recently selected cells in the current viewing of the filter VC
        recentlySelectedCells.removeAll()
        // Display all the cheese with the new filters
        dismiss(animated: true, completion: {self.allCheeseVC!.viewDidAppear(true)})
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return FilterViewController.filters.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        // .checkmark or .none
        let currentAccessory = cell.accessoryType
        let selectedFilter = cell.filter.text!
        let sectionTitle = (tableView.headerView(forSection: indexPath.section)?.textLabel?.text)!
        // if the filter is already applied, remove it
        if (currentAccessory == .checkmark) {
            tempFilters["\(sectionTitle)"]?.remove(selectedFilter)
        } else {
            // if the section does not already have a set storing the applied filters we must create an empty set
            if tempFilters["\(sectionTitle)"] == nil {
                tempFilters["\(sectionTitle)"] = Set<String>()
            }
            tempFilters["\(sectionTitle)"]?.insert(selectedFilter)
        }
        // change the cell accessory to be the opposite of what it currently is
        cell.accessoryType = (currentAccessory == .none ? .checkmark : .none)
        // Add this selected cell to the set of recently selected cells,
        // allowing us to toggle the cell's accessory if the user presses cancel
        recentlySelectedCells.insert(cell)
    }
}
