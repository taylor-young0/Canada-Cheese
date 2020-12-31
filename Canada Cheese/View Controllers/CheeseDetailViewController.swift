//
//  CheeseDetailViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-08.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit
import SafariServices

class CheeseDetailViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    // this is the cheese whose details we are displaying on this vc
    var selectedCheese: CanadianCheese?
    var properties = [
        ["Cheese", "Manufacturer", "Manufacturer province", "Manufacturing type", "Website"],
        ["Fat", "Moisture", "Particularities", "Flavour", "Characteristics", "Ripening", "Organic", "Category type", "Milk type", "Milk treatment type", "Rind type"],
        ["Last update"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        // create a favourite button, star is either filled or not depending on its status as a favourite cheese
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: selectedCheese!.isFavourite ? "star.fill" : "star"),
                                                            style: .plain, target: self, action: #selector(toggleFavourite))
    }
    
    @objc func toggleFavourite() {
        // if the cheese is already a favourite, remove it
        if (CanadianCheeses.favouriteCheeses.contains(selectedCheese!)) {
            CanadianCheeses.favouriteCheeses.remove(at: CanadianCheeses.favouriteCheeses.firstIndex(of: selectedCheese!)!)
            CanadianCheeses.favouriteCheesesIDs.remove(at: CanadianCheeses.favouriteCheesesIDs.firstIndex(of: selectedCheese!.cheeseId)!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(toggleFavourite))
        } else {
            // else cheese must not be a favourite, so we can add it now
            CanadianCheeses.favouriteCheeses.append(selectedCheese!)
            CanadianCheeses.favouriteCheesesIDs.append(selectedCheese!.cheeseId)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(toggleFavourite))
        }
        // write the favourite cheese to UserDefaults
        UserDefaults.standard.setValue(CanadianCheeses.favouriteCheesesIDs, forKey: "favouriteCheesesIDs")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return properties.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheeseDetailCell", for: indexPath) as! CheeseDetailCell
        let property = properties[indexPath.section][indexPath.row]
        var propertyValue: String
        
        // display the English first whenever available, else display the French
        // Note that for some properties this can still lead to the propertyValue
        // being a blank string.
        switch property {
        case "Cheese":
            propertyValue = selectedCheese!.cheeseNameEn != "" ? selectedCheese!.cheeseNameEn : selectedCheese!.cheeseNameFr
        case "Manufacturer":
            propertyValue = selectedCheese!.manufacturerNameEn != "" ? selectedCheese!.manufacturerNameEn : selectedCheese!.manufacturerNameFr
        case "Manufacturer province":
            propertyValue = selectedCheese!.manufacturerProvCode
        case "Manufacturing type":
            propertyValue = selectedCheese!.manufacturingTypeEn
        case "Website":
            propertyValue = selectedCheese!.websiteEn
            cell.propertyValue.textColor = UIColor.systemBlue
        case "Fat":
            // no fat % given? Don't display anything
            propertyValue = selectedCheese!.fatContentPercent != "" ? "\(selectedCheese!.fatContentPercent)%" : ""
        case "Moisture":
            // no moisture % given? Don't display anything
            propertyValue = selectedCheese!.moisturePercent != "" ? "\(selectedCheese!.moisturePercent)%" : ""
        case "Particularities":
            propertyValue = selectedCheese!.particularitiesEn != "" ? selectedCheese!.particularitiesEn : selectedCheese!.particularitiesFr
        case "Flavour":
            propertyValue = selectedCheese!.flavourEn != "" ? selectedCheese!.flavourEn : selectedCheese!.flavourFr
        case "Characteristics":
            propertyValue = selectedCheese!.characteristicsEn != "" ? selectedCheese!.characteristicsEn : selectedCheese!.characteristicsFr
        case "Ripening":
            propertyValue = selectedCheese!.ripeningEn != "" ? selectedCheese!.ripeningEn : selectedCheese!.ripeningFr
        case "Organic":
            propertyValue = (selectedCheese!.organic == "1" ? "Organic" : "Non-organic" )
        case "Category type":
            propertyValue = selectedCheese!.categoryTypeEn != "" ? selectedCheese!.categoryTypeEn : selectedCheese!.categoryTypeFr
        case "Milk type":
            propertyValue = selectedCheese!.milkTypeEn != "" ? selectedCheese!.milkTypeEn : selectedCheese!.milkTypeFr
        case "Milk treatment type":
            propertyValue = selectedCheese!.milkTreatmentTypeEn != "" ? selectedCheese!.milkTreatmentTypeEn : selectedCheese!.milkTreatmentTypeFr
        case "Rind type":
            propertyValue = selectedCheese!.rindTypeEn != "" ? selectedCheese!.rindTypeEn : selectedCheese!.rindTypeFr
        case "Last update":
            propertyValue = selectedCheese!.lastUpdateDate
        default:
            propertyValue = ""
        }
        
        cell.propertyName.sizeToFit()
        cell.propertyName.text = properties[indexPath.section][indexPath.row]
        cell.propertyValue.text = propertyValue
        // Make the cell support multiple lines to avoid truncating
        cell.propertyValue.numberOfLines = 0
        cell.propertyValue.sizeToFit()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cheese info"
    }
    
    // change the background between the cell sections
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .secondarySystemBackground
        return headerView
    }
    
    // change the background between the cell sections
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        footerView.backgroundColor = .secondarySystemBackground
        return footerView
    }
    
    // Allow users to click the website cell to load the website
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! CheeseDetailCell
        let website = cell.propertyValue.text!
        if cell.propertyName.text! == "Website" && !website.isEmpty {
            if let url = URL(string: website) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self

                present(vc, animated: true)
            }
        }
    }
}
