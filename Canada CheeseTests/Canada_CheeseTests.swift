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
    
    /// Test that we can parse the cheese directory JSON file
    func testParseJSON() throws {
        let vc = AllCheeseTableViewController()
        
        let urlString = "https://od-do.agr.gc.ca/canadianCheeseDirectory.json"
        
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
    
    /// Test filtering that should result in zero results
    func testZeroFilterResults() throws {
        // veined, nb
        let vc = AllCheeseTableViewController()
        
        FilterViewController.activeFilters["Cheese type"] = ["Veined Cheeses"]
        FilterViewController.activeFilters["Manufacturer province"] = ["NB"]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.categoryTypeEn == "Veined cheeses"
                && $0.manufacturerProvCode == "NB"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for New Brunswick veined cheeses")
        XCTAssert(vc.displayedCheese.count == 0, "Was expecting zero filter results when filtering for New Brunswick veined cheeses but got \(vc.displayedCheese.count)")
        
        // cow and goat, thermised
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Milk type"] = ["Cow and Goat"]
        FilterViewController.activeFilters["Milk treatment"] = ["Thermised"]
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
        
        FilterViewController.activeFilters["Manufacturing type"] = ["Farmstead"]
        FilterViewController.activeFilters["Manufacturer province"] = ["MB", "NB"]
        FilterViewController.activeFilters["Organic"] = ["Organic"]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.manufacturingTypeEn == "Farmstead"
                && ($0.manufacturerProvCode == "MB" || $0.manufacturerProvCode == "NB")
                && $0.organic == "1"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexepected filter results when filtering for New Brunswick or Manitoba organic farmstead cheese")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Cheese type"] = ["Soft Cheese"]
        FilterViewController.activeFilters["Milk type"] = ["Ewe"]
        FilterViewController.activeFilters["Milk treatment"] = ["Raw Milk"]
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
        
        FilterViewController.activeFilters["Milk type"] = ["Goat", "Cow", "Buffalo Cow"]
        vc.displayedCheese = vc.filterCheese()
        
        allCheese = allCheese.filter({
            $0.milkTypeEn == "Goat"
                || $0.milkTypeEn == "Cow"
                || $0.milkTypeEn == "Buffalo Cow"
        })
        
        XCTAssert(allCheese == vc.displayedCheese, "Got unexpected filter results when filtering for goat, cow, or buffalo cow cheese")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Manufacturing type"] = ["Farmstead", "Industrial"]
        FilterViewController.activeFilters["Rind type"] = ["Washed Rind", "Brushed Rind"]
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
        
        FilterViewController.activeFilters["Manufacturing type"] = ["Artisan", "Farmstead", "Industrial"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(allCheese == vc.displayedCheese, "All cheese should satisfy when filtering with all possible manufacturing types")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Organic"] = ["Organic", "Non-organic"]
        vc.displayedCheese = vc.filterCheese()
        allCheese = CanadianCheeses.allCheeses!
        
        XCTAssert(allCheese == vc.displayedCheese, "All cheese should satisfy when filtering with both organic and non-organic")
    }
    
    /// Test where a cheese search returns no results
    func testZeroSearchResults() throws {
        let vc = AllCheeseTableViewController()
        // allows us to easily change the words if cheese JSON data is altered to now suddenly have one of these keywords
        let words = ["Eggplant", "Aubergine"]
        
        for word in words {
            allCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            allCheese = allCheese.filter({
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
            allCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            allCheese = allCheese.filter({
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
            allCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = CanadianCheeses.allCheeses!
            vc.displayedCheese = vc.displayedCheese.filter({ vc.searchCheese(for: word, on: $0) })
            allCheese = allCheese.filter({
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
    
}
