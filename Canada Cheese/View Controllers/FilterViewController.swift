//
//  FilterTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-04.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    
    // cells that were selected in the current viewing of the vc, used to revert cell selection upon canceling
    var recentlySelectedCells = Set<CheeseFilterCell>()
    var allCheeseVC: AllCheeseTableViewController?
    
    // tempFilters is used to store the previously applied filters
    // i.e., if filters have been applied n times, activeFilters is the nth filters applied and tempFilters is the (n-1)th filters applied
    // tempFilters helps to revert recently applied filters when the user presses 'cancel' on the FilterViewController
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
        
        // cancel and done buttons to disregard or apply recently selected filters and go back to the main app screen
        let cancel = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: "Cancel button text"), style: .plain, target: self, action: #selector(dismissAndCancel))
        cancel.tintColor = .systemRed
        
        let done = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dismissAndApply))
        done.tintColor = .systemRed
        
        self.navigationItem.leftBarButtonItems = [cancel]
        self.navigationItem.titleView = setTitle(title: NSLocalizedString("Filter", comment: "Filter sheet navigation header text"), subtitle: "\(allCheeseVC!.displayedCheese.count) \(NSLocalizedString("Results", comment: "Follows the cheese filter results count"))")
        self.navigationItem.rightBarButtonItems = [done]
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
        FilterViewController.activeFilters = tempFilters
        
        dismiss(animated: true, completion: { [self] in
            allCheeseVC?.displayedCheese = allCheeseVC!.filterCheese()
            allCheeseVC?.tableView.reloadData()
            navigationItem.titleView = setTitle(title: NSLocalizedString("Filter", comment: ""), subtitle: "\(allCheeseVC!.displayedCheese.count) \(NSLocalizedString("Results", comment: ""))")
        })
    }
    
    /// Dismiss the FilterViewController and applies the new filters.
    @objc func dismissAndApply() {
        // Since the filter VC is about to be dismissed there are no longer any recently selected cells in the current viewing of the filter VC
        recentlySelectedCells.removeAll()
        
        // Display all the cheese with the new filters
        dismiss(animated: true, completion: { [self] in
            allCheeseVC?.displayedCheese = allCheeseVC!.filterCheese()
            navigationItem.titleView = setTitle(title: NSLocalizedString("Filter", comment: ""), subtitle: "\(allCheeseVC!.displayedCheese.count) \(NSLocalizedString("Results", comment: ""))")
        })
    }
    
    // Modified from https://gist.github.com/nazywamsiepawel/0166e8a71d74e96c7898 and https://stackoverflow.com/a/38628080
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x:0, y:-5, width:0, height:0))
        
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y:18, width:0, height:0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .label
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:0, y:0, width:max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height:30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = frame.integral
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = frame.integral
        }
        
        return titleView
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
        let sectionHeader = FilterViewController.filters[indexPath.section]?.first?.key
        
        cell.filter.text = FilterViewController.filters[indexPath.section]!.first?.value[indexPath.row]
        cell.accessoryType = FilterViewController.activeFilters[sectionHeader!]!.contains(cell.filter.text!) ? .checkmark : .none

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
        let filterCategory = (tableView.headerView(forSection: indexPath.section)?.textLabel?.text)!
        
        // if the filter is already applied, remove it
        if currentAccessory == .checkmark {
            FilterViewController.activeFilters[filterCategory]?.remove(selectedFilter)
            
            allCheeseVC?.displayedCheese = allCheeseVC!.filterCheese()
            allCheeseVC?.tableView.reloadData()
            
            self.navigationItem.titleView = setTitle(title: NSLocalizedString("Filter", comment: "Filter sheet navigation header text"), subtitle: "\(allCheeseVC!.displayedCheese.count) \(NSLocalizedString("Results", comment: ""))")
        } else {
            FilterViewController.activeFilters[filterCategory]?.insert(selectedFilter)
            
            allCheeseVC?.displayedCheese = allCheeseVC!.filterCheese()
            allCheeseVC?.tableView.reloadData()
            
            self.navigationItem.titleView = setTitle(title: NSLocalizedString("Filter", comment: "Filter sheet navigation header text"), subtitle: "\(allCheeseVC!.displayedCheese.count) \(NSLocalizedString("Results", comment: ""))")
        }
        
        // change the cell accessory to be the opposite of what it currently is
        cell.accessoryType = (currentAccessory == .none ? .checkmark : .none)
        tableView.reloadData()
        
        // Add this selected cell to the set of recently selected cells,
        // allowing us to toggle the cell's accessory if the user presses cancel
        //
        // Note: recentlySelectedCells is a set, i.e. each cell is in there at most once
        // but we want to remove the cell if the recentlySelectedCells already contains the cell
        // because the user is undoing their first selection
        if !recentlySelectedCells.contains(cell) {
            recentlySelectedCells.insert(cell)
        } else {
            recentlySelectedCells.remove(cell)
        }
    }
}
