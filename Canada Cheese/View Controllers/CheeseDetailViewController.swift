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
        [
            NSLocalizedString("Cheese", comment: "Cheese name"),
            NSLocalizedString("Manufacturer", comment: "Cheese manufacturer"),
            NSLocalizedString("Manufacturer province", comment: ""),
            NSLocalizedString("Manufacturing type", comment: ""),
            NSLocalizedString("Website", comment: "")
        ],
        [
            NSLocalizedString("Fat", comment: ""),
            NSLocalizedString("Moisture", comment: ""),
            NSLocalizedString("Particularities", comment: ""),
            NSLocalizedString("Flavour", comment: ""),
            NSLocalizedString("Characteristics", comment: ""),
            NSLocalizedString("Ripening", comment: ""),
            NSLocalizedString("Organic", comment: ""),
            NSLocalizedString("Cheese type", comment: ""),
            NSLocalizedString("Milk type", comment: ""),
            NSLocalizedString("Milk treatment", comment: ""),
            NSLocalizedString("Rind type", comment: "")
        ],
        [
            NSLocalizedString("Last update", comment: "")
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        // create a favourite button, star is either filled or not depending on its status as a favourite cheese
        if selectedCheese != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: selectedCheese!.isFavourite ? "star.fill" : "star"),
                                                            style: .plain, target: self, action: #selector(toggleFavourite))
        }
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
        return selectedCheese == nil ? 0 : properties.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheeseDetailCell", for: indexPath) as! CheeseDetailCell
        let property = properties[indexPath.section][indexPath.row]
        
        // display the English first whenever available, else display the French
        // Note that for some properties this can still lead to the propertyValue
        // being a blank string.
        var propertyValue = CheeseDetailViewController.propertyValue(for: property, on: selectedCheese!, inLocale: Bundle.main.preferredLocalizations.first ?? "")
        
        if propertyValue.isEmpty {
            propertyValue = "-"
            cell.propertyValue.textColor = .systemGray
        }
        
        // make website URL have red colour
        if property == NSLocalizedString("Website", comment: "") {
            if let url = URL(string: propertyValue) {
                // if the url is valid website url
                if url.absoluteString.hasPrefix("http") {
                    cell.propertyValue.textColor = .systemRed
                }
            }
        }
        
        cell.propertyName.sizeToFit()
        cell.propertyName.text = properties[indexPath.section][indexPath.row]
        cell.propertyValue.text = propertyValue
        // Make the cell support multiple lines to avoid truncating
        cell.propertyValue.numberOfLines = 0
        cell.propertyValue.sizeToFit()
        
        return cell
    }
    
    // Allow users to click the website cell to load the website
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! CheeseDetailCell
        let website = cell.propertyValue.text!
        if cell.propertyName.text! == NSLocalizedString("Website", comment: "") && website.hasPrefix("http") {
            if let url = URL(string: website) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self

                present(vc, animated: true)
            }
        }
    }
    
    static func propertyValue(for property: String, on cheese: CanadianCheese, inLocale locale: String) -> String {
        // if French (Canada), prefer French before English values
        if locale == "fr-CA" {
            switch property {
            case NSLocalizedString("Cheese", comment: ""):
                return cheese.cheeseNameFr != "" ? cheese.cheeseNameFr : cheese.cheeseNameEn
            case NSLocalizedString("Manufacturer", comment: ""):
                return cheese.manufacturerNameFr != "" ? cheese.manufacturerNameFr : cheese.manufacturerNameEn
            case NSLocalizedString("Manufacturer province", comment: ""):
                return cheese.manufacturerProvCode
            case NSLocalizedString("Manufacturing type", comment: ""):
                return cheese.manufacturingTypeFr != "" ? cheese.manufacturingTypeFr : cheese.manufacturingTypeEn
            case NSLocalizedString("Website", comment: ""):
                return cheese.websiteFixed
            case NSLocalizedString("Fat", comment: ""):
                // no fat % given? Don't display the percentage sign!
                return cheese.fatContentPercent != "" ? "\(cheese.fatContentPercent)%" : ""
            case NSLocalizedString("Moisture", comment: ""):
                // no moisture % given? Don't display the percentage sign!
                return cheese.moisturePercent != "" ? "\(cheese.moisturePercent)%" : ""
            case NSLocalizedString("Particularities", comment: ""):
                return cheese.particularitiesFr != "" ? cheese.particularitiesFr : cheese.particularitiesEn
            case NSLocalizedString("Flavour", comment: ""):
                return cheese.flavourFr != "" ? cheese.flavourFr : cheese.flavourEn
            case NSLocalizedString("Characteristics", comment: ""):
                return cheese.characteristicsFr != "" ? cheese.characteristicsFr : cheese.characteristicsEn
            case NSLocalizedString("Ripening", comment: ""):
                return cheese.ripeningFr != "" ? cheese.ripeningFr : cheese.ripeningEn
            case NSLocalizedString("Organic", comment: ""):
                return (cheese.organic == "1" ? NSLocalizedString("Organic", comment: "") : NSLocalizedString("Non-organic", comment: ""))
            case NSLocalizedString("Cheese type", comment: ""):
                return cheese.categoryTypeFr != "" ? cheese.categoryTypeFr : cheese.categoryTypeEn
            case NSLocalizedString("Milk type", comment: ""):
                return cheese.milkTypeFr != "" ? cheese.milkTypeFr : cheese.milkTypeEn
            case NSLocalizedString("Milk treatment", comment: ""):
                return cheese.milkTreatmentTypeFr != "" ? cheese.milkTreatmentTypeFr : cheese.milkTreatmentTypeEn
            case NSLocalizedString("Rind type", comment: ""):
                return cheese.rindTypeFr != "" ? cheese.rindTypeFr : cheese.rindTypeEn
            case NSLocalizedString("Last update", comment: ""):
                return cheese.lastUpdated
            default:
                return ""
            }
        } else {
            // assume user wants English, if not present we display French
            // Note that this can still result in empty Strings being returned if neither French nor English have text values
            switch property {
            case NSLocalizedString("Cheese", comment: ""):
                return cheese.cheeseNameEn != "" ? cheese.cheeseNameEn : cheese.cheeseNameFr
            case NSLocalizedString("Manufacturer", comment: ""):
                return cheese.manufacturerNameEn != "" ? cheese.manufacturerNameEn : cheese.manufacturerNameFr
            case NSLocalizedString("Manufacturer province", comment: ""):
                return cheese.manufacturerProvCode
            case NSLocalizedString("Manufacturing type", comment: ""):
                return cheese.manufacturingTypeEn != "" ? cheese.manufacturingTypeEn : cheese.manufacturingTypeFr
            case NSLocalizedString("Website", comment: ""):
                return cheese.websiteFixed
            case NSLocalizedString("Fat", comment: ""):
                // no fat % given? Don't display the percentage sign!
                return cheese.fatContentPercent != "" ? "\(cheese.fatContentPercent)%" : ""
            case NSLocalizedString("Moisture", comment: ""):
                // no moisture % given? Don't display the percentage sign!
                return cheese.moisturePercent != "" ? "\(cheese.moisturePercent)%" : ""
            case NSLocalizedString("Particularities", comment: ""):
                return cheese.particularitiesEn != "" ? cheese.particularitiesEn : cheese.particularitiesFr
            case NSLocalizedString("Flavour", comment: ""):
                return cheese.flavourEn != "" ? cheese.flavourEn : cheese.flavourFr
            case NSLocalizedString("Characteristics", comment: ""):
                return cheese.characteristicsEn != "" ? cheese.characteristicsEn : cheese.characteristicsFr
            case NSLocalizedString("Ripening", comment: ""):
                return cheese.ripeningEn != "" ? cheese.ripeningEn : cheese.ripeningFr
            case NSLocalizedString("Organic", comment: ""):
                return (cheese.organic == "1" ? NSLocalizedString("Organic", comment: "") : NSLocalizedString("Non-organic", comment: ""))
            case NSLocalizedString("Cheese type", comment: ""):
                return cheese.categoryTypeEn != "" ? cheese.categoryTypeEn : cheese.categoryTypeFr
            case NSLocalizedString("Milk type", comment: ""):
                return cheese.milkTypeEn != "" ? cheese.milkTypeEn : cheese.milkTypeFr
            case NSLocalizedString("Milk treatment", comment: ""):
                return cheese.milkTreatmentTypeEn != "" ? cheese.milkTreatmentTypeEn : cheese.milkTreatmentTypeFr
            case NSLocalizedString("Rind type", comment: ""):
                return cheese.rindTypeEn != "" ? cheese.rindTypeEn : cheese.rindTypeFr
            case NSLocalizedString("Last update", comment: ""):
                return cheese.lastUpdated
            default:
                return ""
            }
        }
    }
}
