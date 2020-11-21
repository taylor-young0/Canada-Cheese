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
            CanadianCheeses.favouriteCheesesIDs.remove(at: CanadianCheeses.favouriteCheesesIDs.firstIndex(of: selectedCheese!.CheeseId)!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(toggleFavourite))
        } else {
            // else cheese must not be a favourite, so we can add it now
            CanadianCheeses.favouriteCheeses.append(selectedCheese!)
            CanadianCheeses.favouriteCheesesIDs.append(selectedCheese!.CheeseId)
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
            propertyValue = selectedCheese!.CheeseNameEn != "" ? selectedCheese!.CheeseNameEn : selectedCheese!.CheeseNameFr
        case "Manufacturer":
            propertyValue = selectedCheese!.ManufacturerNameEn != "" ? selectedCheese!.ManufacturerNameEn : selectedCheese!.ManufacturerNameFr
        case "Manufacturer province":
            propertyValue = selectedCheese!.ManufacturerProvCode
        case "Manufacturing type":
            propertyValue = selectedCheese!.ManufacturingTypeEn
        case "Website":
            propertyValue = selectedCheese!.WebSiteEn
            cell.propertyValue.textColor = UIColor.systemBlue
        case "Fat":
            // no fat % given? Don't display anything
            propertyValue = selectedCheese!.FatContentPercent != "" ? "\(selectedCheese!.FatContentPercent)%" : ""
        case "Moisture":
            // no moisture % given? Don't display anything
            propertyValue = selectedCheese!.MoisturePercent != "" ? "\(selectedCheese!.MoisturePercent)%" : ""
        case "Particularities":
            propertyValue = selectedCheese!.ParticularitiesEn != "" ? selectedCheese!.ParticularitiesEn : selectedCheese!.ParticularitiesFr
        case "Flavour":
            propertyValue = selectedCheese!.FlavourEn != "" ? selectedCheese!.FlavourEn : selectedCheese!.FlavourFr
        case "Characteristics":
            propertyValue = selectedCheese!.CharacteristicsEn != "" ? selectedCheese!.CharacteristicsEn : selectedCheese!.CharacteristicsFr
        case "Ripening":
            propertyValue = selectedCheese!.RipeningEn != "" ? selectedCheese!.RipeningEn : selectedCheese!.RipeningFr
        case "Organic":
            propertyValue = (selectedCheese!.Organic == "1" ? "Organic" : "Non-organic" )
        case "Category type":
            propertyValue = selectedCheese!.CategoryTypeEn != "" ? selectedCheese!.CategoryTypeEn : selectedCheese!.CategoryTypeFr
        case "Milk type":
            propertyValue = selectedCheese!.MilkTypeEn != "" ? selectedCheese!.MilkTypeEn : selectedCheese!.MilkTypeFr
        case "Milk treatment type":
            propertyValue = selectedCheese!.MilkTreatmentTypeEn != "" ? selectedCheese!.MilkTreatmentTypeEn : selectedCheese!.MilkTreatmentTypeFr
        case "Rind type":
            propertyValue = selectedCheese!.RindTypeEn != "" ? selectedCheese!.RindTypeEn : selectedCheese!.RindTypeFr
        case "Last update":
            propertyValue = selectedCheese!.LastUpdateDate
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
