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
    var tempFilters = [
        NSLocalizedString("Manufacturing type", comment: "Defines the method used by the cheese processor to make the cheese. (Artisan, Farmstead, Industrial)"): Set<String>(),
        NSLocalizedString("Manufacturer province", comment: "Province of manufacturer"): Set<String>(),
        NSLocalizedString("Organic", comment: "Indicates that the cheese is organic or not"): Set<String>(),
        NSLocalizedString("Cheese type", comment: "Cheese category"): Set<String>(),
        NSLocalizedString("Milk type", comment: "Type of milk used to make the cheese"): Set<String>(),
        NSLocalizedString("Milk treatment", comment: "How the milk is transformed in order to make cheese. Cheese Milk Treatment Type sample values: Raw Milk Cheese, Pasteurized, Thermised"): Set<String>(),
        NSLocalizedString("Rind type", comment: "Type of Rind. Typical Cheese Rind Type values: Washed Rind, Brushed Rind, Boomy Rind, No Rind"): Set<String>()
    ]
    // filters that are currently active
    static var activeFilters = [
        NSLocalizedString("Manufacturing type", comment: ""): Set<String>(),
        NSLocalizedString("Manufacturer province", comment: ""): Set<String>(),
        NSLocalizedString("Organic", comment: ""): Set<String>(),
        NSLocalizedString("Cheese type", comment: ""): Set<String>(),
        NSLocalizedString("Milk type", comment: ""): Set<String>(),
        NSLocalizedString("Milk treatment", comment: ""): Set<String>(),
        NSLocalizedString("Rind type", comment: ""): Set<String>()
    ]
    static var filters = [
        0 : [NSLocalizedString("Manufacturing type", comment: ""):
                [
                    NSLocalizedString("Artisan", comment: "The milk is processed off the farm premises and uses milk produced from one or several farms using several methods for the manual manufacturing of cheeses."),
                    NSLocalizedString("Farmstead", comment: "The milk is processed at the farm and uses only the milk produced on the farm."),
                    NSLocalizedString("Industrial", comment: "The milk is processed using manufacturing methods that are highly mechanical and automated. The milk comes from several farms.")
                ]
        ],
        1 : [NSLocalizedString("Manufacturer province", comment: "") : ["BC", "AB", "SK", "MB", "ON", "QC", "NL", "NB", "NS", "PE"]],
        2 : [NSLocalizedString("Organic", comment: ""):
                [
                    NSLocalizedString("Organic", comment: ""),
                    NSLocalizedString("Non-organic", comment: "Cheese that is not organic")
                ]
        ],
        3 : [NSLocalizedString("Cheese type", comment: ""):
                [
                    NSLocalizedString("Soft Cheese", comment: "This cheese contains between 67 and 80% moisture."),
                    NSLocalizedString("Semi-soft Cheese", comment: "The semi-soft cheeses contain between 62% and 67% moisture."),
                    NSLocalizedString("Firm Cheese", comment: "This cheese contains 50% and 62% moisture."),
                    NSLocalizedString("Hard Cheese", comment: "This cheese has a moisture of less than 50%."),
                    NSLocalizedString("Veined Cheeses", comment: "The production for the veined cheese is similar to the soft or semi-firm cheeses. It is commonly referred to as blue cheese. This cheese is aged for several months in a humid cave or in a curing room. The cheese is pierced with skewers to help the air circulate through the cheese and facilitate the creation of blue veins."),
                    NSLocalizedString("Fresh Cheese", comment: "Fresh cheese")
                ]
        ],
        4 : [NSLocalizedString("Milk type", comment: ""):
                [
                    NSLocalizedString("Ewe", comment: ""),
                    NSLocalizedString("Ewe and Goat", comment: ""),
                    NSLocalizedString("Ewe and Cow", comment: ""),
                    NSLocalizedString("Goat", comment: ""),
                    NSLocalizedString("Cow", comment: ""),
                    NSLocalizedString("Cow and Goat", comment: ""),
                    NSLocalizedString("Buffalo Cow", comment: ""),
                    NSLocalizedString("Cow, Goat and Ewe", comment: "")
                ]
        ],
        5 : [NSLocalizedString("Milk treatment", comment: ""):
                [
                    NSLocalizedString("Raw Milk", comment: "Milk has not undergone a thermisized treatment above 40°C."),
                    NSLocalizedString("Pasteurized", comment: "Milk has been pasteurized by being held at a temperature of not less than 61.6°C for a period of not less than 30 minutes, or for a time and a temperature that is equivalent thereto in phosphatase destruction, as determined by official methods MFO-3, Determination of Phosphatase Activity in Dairy Products, November 30, 1981 (i.e. 72°C for 15 seconds)."),
                    NSLocalizedString("Thermised", comment: "Milk has undergone a short and advanced thermal treatment at a temperature of 59°C to 65°C for a period of 15 to 20 seconds. This procedure eliminates, in part, certain bacteria susceptible to cause an infection and impoverish the lactic flora.")
                ]
        ],
        6 : [NSLocalizedString("Rind type", comment: ""):
                [
                    NSLocalizedString("Washed Rind", comment: "The soft, washed rind cheese has a rich and creamy texture with a slight elasticity in the cheese. During the aging process, the cheese is turned over regularly and brushed or washed in brine with beer, mead, wine or spirits."),
                    NSLocalizedString("Brushed Rind", comment: "This firm, washed, brushed and natural rind cheese has a drier texture and has a certain elasticity. When aging, the cheese can be washed (washed rind) in brine with red smears (with or without alcohol). The cheese can also be brushed and/or develop a natural rind."),
                    NSLocalizedString("No Rind", comment: "Cheese with no rind."),
                    NSLocalizedString("Bloomy Rind", comment: "The soft cheese, bloomy rind has a rich and creamy texture with a slight elasticity in the cheese. The aging process depends on its thickness. This cheese has a mixed coagulation with slow draining, inoculated with specific moulds.")
                ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cancel button to disregard recently selected filters and go back to the main app screen
        let cancel = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel button text"), style: .plain, target: self, action: #selector(dismissAndCancel))
        cancel.tintColor = .systemRed
        // apply button to apply filters and go back to main app screen
        let apply = UIBarButtonItem(title: NSLocalizedString("Apply", comment: "Apply filters button text"), style: .plain, target: self, action: #selector(dismissAndApply))
        apply.tintColor = .systemRed
        
        self.navigationItem.leftBarButtonItems = [cancel]
        self.navigationItem.title = NSLocalizedString("Filter", comment: "Filter sheet navigation header text")
        self.navigationItem.rightBarButtonItems = [apply]
    }
    
    /// Dismiss the FilterViewController and cancels the newly applied filters.
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
    
    /// Dismiss the FilterViewController and applies the new filters.
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
        if currentAccessory == .checkmark {
            tempFilters["\(sectionTitle)"]!.remove(selectedFilter)
        } else {
            tempFilters["\(sectionTitle)"]!.insert(selectedFilter)
        }
        
        // change the cell accessory to be the opposite of what it currently is
        cell.accessoryType = (currentAccessory == .none ? .checkmark : .none)
        // Add this selected cell to the set of recently selected cells,
        // allowing us to toggle the cell's accessory if the user presses cancel
        recentlySelectedCells.insert(cell)
    }
}
