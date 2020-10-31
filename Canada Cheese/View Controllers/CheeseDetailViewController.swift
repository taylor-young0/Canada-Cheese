//
//  CheeseDetailViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-08.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class CheeseDetailViewController: UITableViewController {
    
    var selectedCheese: CanadianCheese?
    var properties = [
        ["Cheese", "Manufacturer", "Manufacturer province", "Manufacturing type", "Website"],
        ["Fat", "Moisture", "Particularities", "Flavour", "Characteristics", "Ripening", "Organic", "Category type", "Milk type", "Milk treatment type", "Rind type"],
        ["Last update"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: selectedCheese!.isFavourite ? "star.fill" : "star"),
                                                            style: .plain, target: self, action: #selector(toggleFavourite))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func toggleFavourite() {
        if (AppDelegate.favouriteCheeses.contains(selectedCheese!)) {
            AppDelegate.favouriteCheeses.remove(at: AppDelegate.favouriteCheeses.firstIndex(of: selectedCheese!)!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(toggleFavourite))
        } else {
            AppDelegate.favouriteCheeses.append(selectedCheese!)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(toggleFavourite))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return properties.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheeseDetailCell", for: indexPath) as! CheeseDetailCell
        let property = properties[indexPath.section][indexPath.row]
        var propertyValue: String
        
        switch property {
        case "Cheese":
            propertyValue = selectedCheese!.CheeseNameEn
        case "Manufacturer":
            propertyValue = selectedCheese!.ManufacturerNameEn
        case "Manufacturer province":
            propertyValue = selectedCheese!.ManufacturerProvCode
        case "Manufacturing type":
            propertyValue = selectedCheese!.ManufacturingTypeEn
        case "Website":
            propertyValue = selectedCheese!.WebSiteEn
            cell.propertyValue.textColor = UIColor.systemBlue
        case "Fat":
            propertyValue = "\(selectedCheese!.FatContentPercent)%"
        case "Moisture":
            propertyValue = "\(selectedCheese!.MoisturePercent)%"
        case "Particularities":
            propertyValue = selectedCheese!.ParticularitiesEn
        case "Flavour":
            propertyValue = selectedCheese!.FlavourEn
        case "Characteristics":
            propertyValue = selectedCheese!.CharacteristicsEn
        case "Ripening":
            propertyValue = selectedCheese!.RipeningEn
        case "Organic":
            propertyValue = (selectedCheese!.Organic == "1" ? "Organic" : "Non-organic" )
        case "Category type":
            propertyValue = selectedCheese!.CategoryTypeEn
        case "Milk type":
            propertyValue = selectedCheese!.MilkTypeEn
        case "Milk treatment type":
            propertyValue = selectedCheese!.MilkTreatmentTypeEn
        case "Rind type":
            propertyValue = selectedCheese!.RindTypeEn
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

    // TODO: Right now this does nothing because of the custom header below, so fix it
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Info"
        case 1:
            return "Other Info"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = .secondarySystemBackground
        return headerView
    }
    
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
            UIApplication.shared.open(NSURL(string:"\(website)")! as URL)
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
