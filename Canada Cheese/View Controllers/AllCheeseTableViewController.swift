//
//  AllCheeseTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class AllCheeseTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var filterVC: FilterViewController?
    var displayedCheese = [CanadianCheese]()
    var selectedRow: Int?

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
        
        // Filter the cheese given the active filters
        displayedCheese = CanadianCheeses.allCheeses!.filter({filterCheese(named: $0)})
        
//        FilterViewController.activeFilters["Manufacturing type"] = ["Artisan", "Industrial"]
        
        // set the title and the size of the title in the navigation bar
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
        navigationBar?.topItem?.title = "Canada Cheese"
        // add the filter button to the navigation bar
        let filter = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(displayFilters))
        navigationBar?.topItem?.rightBarButtonItems = [filter]
        
        filterVC = (storyboard?.instantiateViewController(identifier: "filterViewController") as! FilterViewController)
        filterVC?.allCheeseVC = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayedCheese = CanadianCheeses.allCheeses!.filter({filterCheese(named: $0)})
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
    
    func filterCheese(named cheese: CanadianCheese) -> Bool {
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
            // TODO: Organic filtering does not work
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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            displayedCheese = CanadianCheeses.allCheeses!
            tableView.reloadData()
            return
        }
        
        // TO DO: Make this search on the currently filtered cheese, that way you can search and filter at the same time
        displayedCheese = CanadianCheeses.allCheeses!.filter({searchCheese(forText: text, on: $0)})
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //TO DO: update the tableView when the search bar is exited
        displayedCheese = CanadianCheeses.allCheeses!
        tableView.reloadData()
    }
    
    func searchCheese(forText searchText: String, on cheese: CanadianCheese) -> Bool {
        let searchableAttributes = [cheese.CheeseNameEn, cheese.CheeseNameFr, cheese.FlavourEn, cheese.FlavourFr, cheese.CharacteristicsEn, cheese.CharacteristicsFr, cheese.ManufacturerNameEn, cheese.ManufacturerNameFr, cheese.ParticularitiesEn, cheese.ParticularitiesFr]
        for attribute in searchableAttributes {
            if attribute.lowercased().contains(searchText.lowercased()) {
                return true
            }
        }
        return false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        if let vc = storyboard?.instantiateViewController(identifier: "cheeseDetail") as? CheeseDetailViewController {
            vc.selectedCheese = displayedCheese[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
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
