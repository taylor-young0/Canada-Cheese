//
//  AllCheeseTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class AllCheeseTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filterVC: FilterViewController?
    // all the cheese that is currently displayed, i.e., might be filtered, searched, etc
    var displayedCheese = [CanadianCheese]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the search bar to the view controller
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search cheese"
        navigationItem.searchController = searchBar
        
        // Load the JSON data
        if let url = Bundle.main.url(forResource: "canadianCheeseDirectory", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                print("error")
            }
        }
        
        let userDefaults = UserDefaults.standard
        let allCheeses = CanadianCheeses.allCheeses
        // load the favourite cheeses, or just use an empty String array if there are currently none saved
        CanadianCheeses.favouriteCheesesIDs = userDefaults.array(forKey: "favouriteCheesesIDs") as? [String] ?? [String]()
        // create the favourite cheeses array from the cheese ids
        CanadianCheeses.favouriteCheeses = allCheeses?.filter({CanadianCheeses.favouriteCheesesIDs.contains($0.CheeseId)}) ?? [CanadianCheese]()
        
        // Filter the cheese given the active filters
        displayedCheese = CanadianCheeses.allCheeses!.filter({filterCheese($0)})
        
        // set the title and the size of the title in the navigation bar
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
        navigationBar?.topItem?.title = "Canada Cheese"
        // add the filter button to the navigation bar
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(displayFilters))
        navigationBar?.topItem?.rightBarButtonItems = [filter]
        
        // prepare a filterViewController for filtering through the cheeses
        filterVC = (storyboard?.instantiateViewController(identifier: "filterViewController") as! FilterViewController)
        filterVC?.allCheeseVC = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // filter cheese, as we might have just gotten back from filtering vc!
        displayedCheese = CanadianCheeses.allCheeses!.filter({filterCheese($0)})
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCheese = try? decoder.decode(CanadianCheeses.self, from: json) {
            CanadianCheeses.allCheeses = jsonCheese.CheeseDirectory
        }
    }
    
    @objc func displayFilters() {
        let navController = UINavigationController(rootViewController: filterVC!)
        present(navController, animated: true)
    }
    
    func filterCheese(_ cheese: CanadianCheese) -> Bool {
        var isIncluded = true
        // loop through each filter category
        for (filterCategory, filters) in FilterViewController.activeFilters {
            // exit early if we already don't satisfy the results
            if isIncluded == false {
                return isIncluded
            }
            
            // determine which filter to apply
            var satisfiesAtleastOneFilter = false
            switch filterCategory {
            case "Manufacturing type":
                if filters.isEmpty {
                    return true;
                }
                for filterOption in filters {
                    if cheese.ManufacturingTypeEn == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Manufacturer province":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if cheese.ManufacturerProvCode == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Organic":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if filterOption == "Organic" && cheese.isOrganic || filterOption == "Non-organic" && !cheese.isOrganic {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Cheese type":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if cheese.CategoryTypeEn == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Milk type":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if cheese.MilkTypeEn == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Milk treatment":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if cheese.MilkTreatmentTypeEn == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            case "Rind type":
                if filters.isEmpty {
                    return true
                }
                for filterOption in filters {
                    if cheese.RindTypeEn == filterOption {
                        satisfiesAtleastOneFilter = true
                        break
                    }
                }
                isIncluded = satisfiesAtleastOneFilter
            default:
                print("default case")
            }
        }
        return isIncluded
    }
    
    // MARK: - Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        // if there is no text then all cheese match because there's no text!
        guard let text = searchController.searchBar.text else {
            displayedCheese = CanadianCheeses.allCheeses!
            tableView.reloadData()
            return
        }
        
        // search the cheese for the given text
        displayedCheese = CanadianCheeses.allCheeses!.filter({searchCheese(forText: text, on: $0)})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // no search to apply so reset the displayed cheese
        displayedCheese = CanadianCheeses.allCheeses!
        tableView.reloadData()
    }
    
    func searchCheese(forText searchText: String, on cheese: CanadianCheese) -> Bool {
        // These are our searchable cheese attributes
        let searchableAttributes = [cheese.CheeseNameEn, cheese.CheeseNameFr, cheese.FlavourEn, cheese.FlavourFr, cheese.CharacteristicsEn, cheese.CharacteristicsFr, cheese.ManufacturerNameEn, cheese.ManufacturerNameFr, cheese.ParticularitiesEn, cheese.ParticularitiesFr]
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
        // Default to using the English value for the cell labels
        var cheeseName = displayedCheese[indexPath.row].CheeseNameEn
        var cheeseManufacturer = displayedCheese[indexPath.row].ManufacturerNameEn
        var cheeseFlavourDesc = displayedCheese[indexPath.row].FlavourEn
        
        // If the English name is empty check for the French
        // Note: cheeseName could still be empty after this if the French version is also empty
        if cheeseName.isEmpty {
            cheeseName = displayedCheese[indexPath.row].CheeseNameFr
        }
        // See if the English manufacturer is empty, if so try the French
        // Note: This does not guarantee that cheeseManufacturer is non-empty
        if cheeseManufacturer.isEmpty {
            cheeseManufacturer = displayedCheese[indexPath.row].ManufacturerNameFr
        }
        // See if the English flavour is empty
        // Note: This does not guarantee that cheeseFlavourDesc is non-empty
        if cheeseFlavourDesc.isEmpty {
            cheeseFlavourDesc = displayedCheese[indexPath.row].CharacteristicsEn
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
}
