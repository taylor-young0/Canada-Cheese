//
//  AllCheeseTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class AllCheeseTableViewController: UITableViewController, UISearchResultsUpdating, TabBarReselectHandling {
    
    var settingsVC: SettingsViewController?
    var filterVC: FilterViewController?
    // all the cheese that is currently displayed, i.e., might be filtered, searched, etc
    var displayedCheese = [CanadianCheese]()
    var navigationBarOffset: CGFloat = 0.0
    var activeFilters = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the search bar to the view controller
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = NSLocalizedString("Search cheese", comment: "Cheese search bar placeholder text")
        searchBar.searchBar.tintColor = .systemRed
        navigationItem.searchController = searchBar
        
        // set the title and the size of the title in the navigation bar
        let navigationBar = navigationController!.navigationBar
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(displaySettings))
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(displayFilters))
        
        navigationBar.topItem?.leftBarButtonItems = [settings]
        navigationBar.topItem?.title = "Canada Cheese"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.rightBarButtonItems = [filter]
        
        // this navigation bar offset is used to help scroll our view back up to the top
        // it is equal to nav bar height + status bar height
        navigationBarOffset = navigationBar.frame.height + (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
        
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        // load up the favourite cheeses or use an empty String array if there are none
        let userDefaults = UserDefaults.standard
        let allCheeses = CanadianCheeses.allCheeses

        CanadianCheeses.favouriteCheesesIDs = userDefaults.array(forKey: "favouriteCheesesIDs") as? [String] ?? [String]()
        CanadianCheeses.favouriteCheeses = allCheeses?.filter({ CanadianCheeses.favouriteCheesesIDs.contains($0.cheeseId) }) ?? [CanadianCheese]()
        
        // prepare a settings and filtering view controllers
        settingsVC = (storyboard?.instantiateViewController(identifier: "settingsViewController"))! as SettingsViewController
        filterVC = (storyboard?.instantiateViewController(identifier: "filterViewController"))! as FilterViewController
        filterVC!.allCheeseVC = self
        
        // Load the JSON data
        let urlString = "https://od-do.agr.gc.ca/canadianCheeseDirectory.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                displayedCheese = filterCheese()
            } else {
                print("error")
                displayedCheese = [CanadianCheese]()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.global().async { [self] in
            // Load the JSON data
            let urlString = "https://od-do.agr.gc.ca/canadianCheeseDirectory.json"
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    
                    // filter the cheese and find the user's favourites
                    displayedCheese = filterCheese()
                    CanadianCheeses.favouriteCheeses = CanadianCheeses.allCheeses?.filter({ CanadianCheeses.favouriteCheesesIDs.contains($0.cheeseId) }) ?? [CanadianCheese]()
                } else {
                    print("error")
                    displayedCheese = [CanadianCheese]()
                }
            }
            
            // reload the table view after data has been fetched and parsed
            DispatchQueue.main.async {
                tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    /// Parses and saves the JSON cheese directory to `CanadianCheeses.allCheeses`
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCheese = try? decoder.decode(CanadianCheeses.self, from: json) {
            CanadianCheeses.allCheeses = jsonCheese.cheeseDirectory
        }
    }
    
    /// Displays the filter view controller
    @objc func displayFilters() {
        let navController = UINavigationController(rootViewController: filterVC!)
        
        filterVC?.isModalInPresentation = true
        // tempFilters is used to store the previously applied filters
        // i.e., if filters have been applied n times, activeFilters is the nth filters applied and tempFilters is the (n-1)th filters applied
        // tempFilters helps to revert recently applied filters when the user presses 'cancel' on the FilterViewController
        filterVC?.tempFilters = FilterViewController.activeFilters
        filterVC?.tableView.reloadData()
        
        present(navController, animated: true)
    }
    
    @objc func displaySettings() {
        let navController = UINavigationController(rootViewController: settingsVC!)
        present(navController, animated: true)
    }
    
    /// Filters through all the cheese in `CanadianCheeses.allCheese` using the filters
    /// given in `FilterViewController.activeFilters`
    func filterCheese() -> [CanadianCheese] {
        let activeFilters = FilterViewController.activeFilters
        
        let manufacturingTypeFilters = activeFilters[NSLocalizedString("Manufacturing type", comment: "")]!
        let manufacturingProvFilters = activeFilters[NSLocalizedString("Manufacturer province", comment: "")]!
        let organicFilters = activeFilters[NSLocalizedString("Organic", comment: "")]!
        let cheeseTypeFilters = activeFilters[NSLocalizedString("Cheese type", comment: "")]!
        let milkTypeFilters = activeFilters[NSLocalizedString("Milk type", comment: "")]!
        let milkTreatmentFilters = activeFilters[NSLocalizedString("Milk treatment", comment: "")]!
        let rindTypeFilters = activeFilters[NSLocalizedString("Rind type", comment: "")]!
        
        // cheese is included if either
        //      1. the applied filters contain the cheese's appropriate property value
        //      2. or that property has no applied filters
        return CanadianCheeses.allCheeses!.filter({
            (manufacturingTypeFilters.count == 0 || manufacturingTypeFilters.contains($0.manufacturingTypeEn) || manufacturingTypeFilters.contains($0.manufacturingTypeFr)) &&
            (manufacturingProvFilters.count == 0 || manufacturingProvFilters.contains($0.manufacturerProvCode)) &&
            (organicFilters.count == 0 || organicFilters.contains($0.organic == "1" ? NSLocalizedString("Organic", comment: "") : NSLocalizedString("Non-organic", comment: ""))) &&
            (cheeseTypeFilters.count == 0 || cheeseTypeFilters.contains($0.categoryTypeEn) || cheeseTypeFilters.contains($0.categoryTypeFr)) &&
            (milkTypeFilters.count == 0 || milkTypeFilters.contains($0.milkTypeEn) || milkTypeFilters.contains($0.milkTypeFr)) &&
            (milkTreatmentFilters.count == 0 || milkTreatmentFilters.contains($0.milkTreatmentTypeEn) || milkTreatmentFilters.contains($0.milkTreatmentTypeFr)) &&
            (rindTypeFilters.count == 0 || rindTypeFilters.contains($0.rindTypeEn) || rindTypeFilters.contains($0.rindTypeFr))
        })
    }
    
    // MARK: - Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        // if there is no text then all cheese match because there's no text!
        guard let text = searchController.searchBar.text else {
            displayedCheese = CanadianCheeses.allCheeses!
            tableView.reloadData()
            return
        }
        
        // if there is text but it is just an empty string
        if searchController.searchBar.text!.isEmpty {
            displayedCheese = CanadianCheeses.allCheeses!
            tableView.reloadData()
            return
        }
        // search the cheese for the given text
        displayedCheese = CanadianCheeses.allCheeses!.filter({searchCheese(for: text, on: $0)})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // no search to apply so reset the displayed cheese
        displayedCheese = CanadianCheeses.allCheeses!
        tableView.reloadData()
    }
    
    
    /// Returns a boolean representing whether any of the cheese's searchable attributes
    /// contains the search text
    /// - parameter searchText: string to search for
    /// - parameter cheese: the cheese whose properties are being searched
    /// - returns: true if the search text is found
    func searchCheese(for searchText: String, on cheese: CanadianCheese) -> Bool {
        // These are our searchable cheese attributes
        let searchableAttributes = [cheese.cheeseNameEn, cheese.cheeseNameFr, cheese.flavourEn, cheese.flavourFr, cheese.characteristicsEn, cheese.characteristicsFr, cheese.manufacturerNameEn, cheese.manufacturerNameFr, cheese.particularitiesEn, cheese.particularitiesFr]
        
        // if search is empty, every search is fine
        if searchText.isEmpty {
            return true
        }
        
        // else look through each attribute, if the searchText is in there, we include this cheese
        for attribute in searchableAttributes {
            if attribute.lowercased().contains(searchText.lowercased()) {
                return true
            }
        }
        return false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCheese.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheeseCell", for: indexPath) as! CheeseCell
        let cheese = displayedCheese[indexPath.row]
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // load up a cheese detail vc
        if let vc = storyboard?.instantiateViewController(identifier: "cheeseDetail") as? CheeseDetailViewController {
            vc.selectedCheese = displayedCheese[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activeFilters.joined(separator: ", ")
    }
    
    // MARK: - Tab bar reselect
    
    func handleReselect() {
        tableView?.setContentOffset(CGPoint(x: 0.0, y: 0 - navigationBarOffset), animated: true)
    }
}
