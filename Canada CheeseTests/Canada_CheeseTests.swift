//
//  Canada_CheeseTests.swift
//  Canada CheeseTests
//
//  Created by Taylor Young on 2021-01-03.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import XCTest

@testable import Canada_Cheese
class Canada_CheeseTests: XCTestCase {
    
    let defaultFilters = FilterViewController.activeFilters
    var allCheese = [CanadianCheese]()
    
    override func setUp() {
        FilterViewController.activeFilters = defaultFilters
        allCheese = CanadianCheeses.allCheeses!
    }
    
    //    /// Test that we can find the cheese directory JSON file
    //    func testForCheeseDirectoryJSONFile() {
    //        let ccd = "canadianCheeseDirectory"
    //
    //        if Bundle.main.url(forResource: ccd, withExtension: "json") == nil {
    //            XCTFail("Could not find \(ccd).json")
    //        }
    //    }
    
    // MARK: - Test Parsing JSON
    
    /// Test that we can parse the cheese directory JSON file
    func testParseJSON() throws {
        let vc = AllCheeseTableViewController()
        
        let urlString = "https://raw.githubusercontent.com/taylor-young0/Canada-Cheese/main/Canada%20Cheese/canadianCheeseDirectory.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                vc.parse(json: data)
            } else {
                XCTFail("Error parsing cheese directory at \(urlString)")
            }
        } else {
            XCTFail("Could not access cheese directory at \(urlString)")
        }
    }
    
    // MARK: - Filtering Tests
    
    /// Test filtering that should result in zero results
    func testZeroFilterResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        // veined, nb
        
        FilterViewController.activeFilters[NSLocalizedString("Cheese type", comment: "")] = [NSLocalizedString("Veined Cheeses", comment: "")]
        FilterViewController.activeFilters[NSLocalizedString("Manufacturer province", comment: "")] = ["NB"]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.categoryTypeEn == "Veined cheeses"
                && $0.manufacturerProvCode == "NB"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for New Brunswick veined cheeses")
        XCTAssert(vc.displayedCheese.count == 0, "Was expecting zero filter results when filtering for New Brunswick veined cheeses but got \(vc.displayedCheese.count)")
        
        // second test
        // cow and goat, thermised
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Milk type", comment: "")] = [NSLocalizedString("Cow and Goat", comment: "")]
        FilterViewController.activeFilters[NSLocalizedString("Milk treatment", comment: "")] = [NSLocalizedString("Thermised", comment: "")]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = CanadianCheeses.allCheeses!
        allCheese = allCheese.filter({
            $0.milkTypeEn == "Cow and Goat"
                && $0.milkTreatmentTypeEn == "Thermised"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for thermised cow and goat cheese")
        XCTAssert(vc.displayedCheese.count == 0, "Was expecting zero filter results when filtering for thermised cow and goat cheese but got \(vc.displayedCheese.count)")
    }
    
    /// Test filtering that should result in a few cheeses
    func testFewFilterResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        FilterViewController.activeFilters[NSLocalizedString("Manufacturing type", comment: "")] = [NSLocalizedString("Farmstead", comment: "")]
        FilterViewController.activeFilters[NSLocalizedString("Manufacturer province", comment: "")] = ["MB", "NB"]
        FilterViewController.activeFilters[NSLocalizedString("Organic", comment: "")] = [NSLocalizedString("Organic", comment: "")]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.manufacturingTypeEn == "Farmstead"
                && ($0.manufacturerProvCode == "MB" || $0.manufacturerProvCode == "NB")
                && $0.organic == "1"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexepected filter results when filtering for New Brunswick or Manitoba organic farmstead cheese")
        
        // second test
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Cheese type", comment: "")] = [NSLocalizedString("Soft Cheese", comment: "")]
        FilterViewController.activeFilters[NSLocalizedString("Milk type", comment: "")] = [NSLocalizedString("Ewe", comment: "")]
        FilterViewController.activeFilters[NSLocalizedString("Milk treatment", comment: "")] = [NSLocalizedString("Raw Milk", comment: "")]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = CanadianCheeses.allCheeses!
        allCheese = allCheese.filter({
            $0.categoryTypeEn == "Soft Cheese"
                && $0.milkTypeEn == "Ewe"
                && $0.milkTreatmentTypeEn == "Raw Milk"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unpected filter results when filtering for soft ewe raw milk cheese")
    }
    
    /// Test filtering that should result in many cheeses
    func testManyFilterResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        FilterViewController.activeFilters[NSLocalizedString("Milk type", comment: "")] = [
            NSLocalizedString("Goat", comment: ""),
            NSLocalizedString("Cow", comment: ""),
            NSLocalizedString("Buffalo Cow", comment: "")
        ]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.milkTypeEn == "Goat"
                || $0.milkTypeEn == "Cow"
                || $0.milkTypeEn == "Buffalo Cow"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for goat, cow, or buffalo cow cheese")
        
        // second test
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Manufacturing type", comment: "")] = [
            NSLocalizedString("Farmstead", comment: ""),
            NSLocalizedString("Industrial", comment: "")
        ]
        FilterViewController.activeFilters[NSLocalizedString("Rind type", comment: "")] = [
            NSLocalizedString("Washed Rind", comment: ""),
            NSLocalizedString("Brushed Rind", comment: "")
        ]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = CanadianCheeses.allCheeses!
        allCheese = allCheese.filter({
            ($0.manufacturingTypeEn == "Farmstead" || $0.manufacturingTypeEn == "Industrial")
                && ($0.rindTypeEn == "Washed Rind" || $0.rindTypeEn == "Brushed Rind")
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for [farmstead or industrial] and [washed rind or brushed rind] cheese")
    }
    
    /// Test that all cheese satisfy the given filters
    func testAllCheeseSatisfyFilterConditions() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        FilterViewController.activeFilters["Manufacturing type"] = ["Artisan", "Farmstead", "Industrial"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(allCheese == vc.displayedCheese, "All cheese should satisfy when filtering with all possible manufacturing types")
        
        // second test
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Organic"] = ["Organic", "Non-organic"]
        vc.displayedCheese = vc.filterCheese()
        allCheese = CanadianCheeses.allCheeses!
        
        XCTAssert(allCheese == vc.displayedCheese, "All cheese should satisfy when filtering with both organic and non-organic")
    }
    
    // MARK: - Searching Tests
    
    /// Test where a cheese search returns no results
    func testZeroSearchResults() throws {
        let vc = AllCheeseTableViewController()
        // allows us to easily change the words if cheese JSON data is altered to now suddenly have one of these keywords
        let words = ["Eggplant", "Aubergine"]
        
        for word in words {
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            
            allCheese = CanadianCheeses.allCheeses!.filter({
                $0.cheeseNameEn.lowercased().contains(word.lowercased())
                    || $0.cheeseNameFr.lowercased().contains(word.lowercased())
                    || $0.flavourEn.lowercased().contains(word.lowercased())
                    || $0.flavourFr.lowercased().contains(word.lowercased())
                    || $0.characteristicsEn.lowercased().contains(word.lowercased())
                    || $0.characteristicsFr.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameEn.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameFr.lowercased().contains(word.lowercased())
                    || $0.particularitiesEn.lowercased().contains(word.lowercased())
                    || $0.particularitiesFr.lowercased().contains(word.lowercased())
            })
            
            XCTAssert(allCheese == vc.displayedCheese, "Got unexpected search results when searching for \(word)")
            XCTAssert(vc.displayedCheese.count == 0, "No cheese search result should contain '\(word)', found \(vc.displayedCheese.count)")
        }
    }
    
    /// Test where a cheese search result returns one result
    func testOneSearchResult() throws {
        let vc = AllCheeseTableViewController()
        
        let words = ["Goat Cheddar (Fifth Town Artisan Cheese)", "Fleurmier"]
        
        for word in words {
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            
            allCheese = CanadianCheeses.allCheeses!.filter({
                $0.cheeseNameEn.lowercased().contains(word.lowercased())
                    || $0.cheeseNameFr.lowercased().contains(word.lowercased())
                    || $0.flavourEn.lowercased().contains(word.lowercased())
                    || $0.flavourFr.lowercased().contains(word.lowercased())
                    || $0.characteristicsEn.lowercased().contains(word.lowercased())
                    || $0.characteristicsFr.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameEn.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameFr.lowercased().contains(word.lowercased())
                    || $0.particularitiesEn.lowercased().contains(word.lowercased())
                    || $0.particularitiesFr.lowercased().contains(word.lowercased())
            })
            
            XCTAssert(allCheese == vc.displayedCheese, "Got unexpected search results when searching for \(word)")
            XCTAssert(vc.displayedCheese.count == 1, "No cheese search result should contain '\(word)', found \(vc.displayedCheese.count)")
        }
    }
    
    /// Test searches that should result in many matching results
    func testManySearchResults() throws {
        let vc = AllCheeseTableViewController()
        
        let words = ["Tangy", "Provolone"]
        
        for word in words {
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            
            allCheese = CanadianCheeses.allCheeses!.filter({
                $0.cheeseNameEn.lowercased().contains(word.lowercased())
                    || $0.cheeseNameFr.lowercased().contains(word.lowercased())
                    || $0.flavourEn.lowercased().contains(word.lowercased())
                    || $0.flavourFr.lowercased().contains(word.lowercased())
                    || $0.characteristicsEn.lowercased().contains(word.lowercased())
                    || $0.characteristicsFr.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameEn.lowercased().contains(word.lowercased())
                    || $0.manufacturerNameFr.lowercased().contains(word.lowercased())
                    || $0.particularitiesEn.lowercased().contains(word.lowercased())
                    || $0.particularitiesFr.lowercased().contains(word.lowercased())
            })
            
            XCTAssert(allCheese == vc.displayedCheese, "Got unexpected search results when searching for \(word)")
        }
    }
    
    /// Test that searching for an empty string return all possible cheese
    func testAllSearchResults() throws {
        let vc = AllCheeseTableViewController()
        
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: "", on: $0) })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected search results when searching for an empty string")
    }
    
    /// Test that the cheese search results are case insensitive
    func testSearchResultCaseInsensitive() throws {
        let vc = AllCheeseTableViewController()
        
        let version1 = CanadianCheeses.allCheeses!.filter({ vc.searchCheese(for: "Blue", on: $0) })
        let version2 = CanadianCheeses.allCheeses!.filter({ vc.searchCheese(for: "BLUE", on: $0) })
        let version3 = CanadianCheeses.allCheeses!.filter({ vc.searchCheese(for: "bLuE", on: $0) })
        
        XCTAssert(version1 == version2, "Search results should be case insensitive")
        XCTAssert(version2 == version3, "Search results should be case insensitive")
    }
    
    // MARK: - Filtering and Searching Tests
    
    /// Test where a cheese filter and search returns no results
    func testZeroFilterAndSearchResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        let firstWord = "Mountain"
        
        FilterViewController.activeFilters[NSLocalizedString("Manufacturer province", comment: "")] = [NSLocalizedString("MB", comment: "")]
            
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: firstWord, on: $0) })
            
        XCTAssert(vc.displayedCheese.count == 0, "No cheese search and filter result from Manitoba should contain '\(firstWord)', found \(vc.displayedCheese.count)")
        
        // second test
        
        let secondWord = "Madawaska"
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Milk type", comment: "")] = [NSLocalizedString("Goat", comment: "")]
        
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: secondWord, on: $0) })
        
        XCTAssert(vc.displayedCheese.count == 0, "No goat cheese search and filter result should contain '\(secondWord)', found \(vc.displayedCheese.count)")
    }
    
    func testFewFilterAndSearchResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        let firstWord = "Mozzarella"
        
        FilterViewController.activeFilters[NSLocalizedString("Milk type", comment: "")] = [NSLocalizedString("Buffalo", comment: "")]
            
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: firstWord, on: $0) })
            
        for cheese in vc.displayedCheese {
            XCTAssert(cheese.milkTypeEn == "Buffalo", "All searches for \(firstWord) cheese should be buffalo when buffalo milk type filtering is applied")
        }
        
        // second test
        
        let secondWord = "Cheddar"
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Milk treatment", comment: "")] = [NSLocalizedString("Raw Milk", comment: "")]
        
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: secondWord, on: $0) })
        
        for cheese in vc.displayedCheese {
            XCTAssert(cheese.milkTreatmentTypeEn == "Raw Milk", "All searches for \(secondWord) should be raw milk when raw milk filtering is applied")
        }
    }
    
    func testManyFilterAndSearchResults() throws {
        let vc = AllCheeseTableViewController()
        
        // first test
        
        let firstWord = "Colo"
        
        FilterViewController.activeFilters[NSLocalizedString("Manufacturing type", comment: "")] = [NSLocalizedString("Artisan", comment: ""), NSLocalizedString("Farmstead", comment: "")]
            
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: firstWord, on: $0) })
            
        for cheese in vc.displayedCheese {
            XCTAssert(cheese.manufacturingTypeEn == "Artisan" || cheese.manufacturingTypeEn == "Farmstead", "All searches for \(firstWord) cheese should be artisan or farmstead when artisan and farmstead filtering is applied")
        }
        
        // second test
        
        let secondWord = "Pepper"
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters[NSLocalizedString("Cheese type", comment: "")] = [NSLocalizedString("Firm Cheese", comment: ""), NSLocalizedString("Soft Cheese", comment: "")]
        
        vc.displayedCheese = CanadianCheeses.allCheeses!
        vc.displayedCheese = vc.filterCheese()
        vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: secondWord, on: $0) })
        
        for cheese in vc.displayedCheese {
            XCTAssert(cheese.categoryTypeEn == "Firm Cheese" || cheese.categoryTypeEn == "Soft Cheese", "All searches for \(secondWord) should be firm or soft cheese when firm and soft cheese filtering is applied")
        }
    }
}
