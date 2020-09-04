//
//  AllCheeseTableViewController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class AllCheeseTableViewController: UITableViewController {
    
    var allCheeses = [CanadianCheese]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the JSON data
        if let url = Bundle.main.url(forResource: "canadianCheeseDirectory", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                print("error")
            }
        }
        
        // set the title and the size of the title in the navigation bar
        let navigationBar = navigationController?.navigationBar
        navigationBar?.prefersLargeTitles = true
        navigationBar?.topItem?.title = "Canada Cheese"
        // add the search button to the navigation bar
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        navigationBar?.topItem?.rightBarButtonItem = search

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCheese = try? decoder.decode(CanadianCheeses.self, from: json) {
            allCheeses = jsonCheese.CheeseDirectory
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allCheeses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cheeseCell", for: indexPath) as! CheeseTableViewCell
        // Default to using the English value for the cell labels
        var cheeseName = allCheeses[indexPath.row].CheeseNameEn
        var cheeseManufacturer = allCheeses[indexPath.row].ManufacturerNameEn
        var cheeseFlavourDesc = allCheeses[indexPath.row].FlavourEn
        
        // If the English name is empty check for the French
        // Note: cheeseName could still be empty after this if the French version is also empty
        if cheeseName.isEmpty {
            cheeseName = allCheeses[indexPath.row].CheeseNameFr
        }
        // See if the English manufacturer is empty, if so try the French
        // Note: This does not guarantee that cheeseManufacturer is non-empty
        if cheeseManufacturer.isEmpty {
            cheeseManufacturer = allCheeses[indexPath.row].ManufacturerNameFr
        }
        // See if the English flavour is empty
        // Note: This does not guarantee that cheeseFlavourDesc is non-empty
        if cheeseFlavourDesc.isEmpty {
            cheeseFlavourDesc = allCheeses[indexPath.row].CharacteristicsEn
        }
        
        cell.cheeseName.text = cheeseName
        cell.manufacturer.text = cheeseManufacturer
        cell.flavourDescription.text = cheeseFlavourDesc
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
