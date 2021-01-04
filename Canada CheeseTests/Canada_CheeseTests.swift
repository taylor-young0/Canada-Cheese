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

    override func setUp() {
        FilterViewController.activeFilters = defaultFilters
    }
    
    /// Test that we can find the cheese directory JSON file
    func testForCheeseDirectoryJSONFile() {
        let ccd = "canadianCheeseDirectory"
        
        if Bundle.main.url(forResource: ccd, withExtension: "json") == nil {
            XCTFail("Could not find \(ccd).json")
        }
    }
    
    /// Test that we can parse the cheese directory JSON file
    func testParseJSON() throws {
        let ccd = "canadianCheeseDirectory"
        let vc = AllCheeseTableViewController()
        
        if let url = Bundle.main.url(forResource: ccd, withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                vc.parse(json: data)
            } else {
                XCTFail("Could not parse \(ccd).json")
            }
        } else {
            XCTFail("Could not find \(ccd).json")
        }
    }
    
    /// Test a case where there should be no results
    func testNoFilterResults() throws {
        let vc = AllCheeseTableViewController()
        
        FilterViewController.activeFilters["Manufacturing type"] = ["Farmstead"]
        FilterViewController.activeFilters["Manufacturer province"] = ["NL"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(vc.displayedCheese.isEmpty, "There should be no farmstead Newfoundland cheese")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Manufacturer province"] = ["PE"]
        FilterViewController.activeFilters["Organic"] = ["Organic"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(vc.displayedCheese.isEmpty, "There should be no organic PEI cheese")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Cheese type"] = ["Semi-soft cheese"]
        FilterViewController.activeFilters["Milk type"] = ["Buffalo Cow"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(vc.displayedCheese.isEmpty, "There should be no buffalo cow semi-soft cheese")
    }
    
    /// Test that there should only be one result from filtering
    func testOneFilterResult() throws {
        let vc = AllCheeseTableViewController()
        
        FilterViewController.activeFilters["Manufacturer province"] = ["SK"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(vc.displayedCheese.count == 1, "There should only be one cheese from Saskatchewan")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Manufacturer province"] = ["NS"]
        FilterViewController.activeFilters["Organic"] = ["Organic"]
        FilterViewController.activeFilters["Cheese type"] = ["Hard Cheese"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(vc.displayedCheese.count == 1, "There should only be one hard organic cheese from Nova Scotia")
    }
    
    /// Test that all cheese satisfy the given filters
    func testAllCheeseSatisfyFilterConditions() throws {
        let vc = AllCheeseTableViewController()
        let cheeseCount = CanadianCheeses.allCheeses!.count
        
        FilterViewController.activeFilters["Manufacturing type"] = ["Artisan", "Farmstead", "Industrial"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(cheeseCount == vc.displayedCheese.count, "All cheese should satisfy when filtering with all possible manufacuring types")
        
        FilterViewController.activeFilters = defaultFilters
        FilterViewController.activeFilters["Organic"] = ["Organic", "Non-organic"]
        vc.displayedCheese = vc.filterCheese()
        
        XCTAssert(cheeseCount == vc.displayedCheese.count, "All cheese should satisfy when filtering with both organic and non-organic")
    }

    /// Test where a cheese search returns no results
    func testNoSearchResults() throws {
        let vc = AllCheeseTableViewController()
        let cheese = CanadianCheeses.allCheeses!
        
        vc.displayedCheese = cheese.filter({vc.searchCheese(for: "Eggplant", on: $0)})
        
        XCTAssert(vc.displayedCheese.count == 0, "No cheese search result should contain 'eggplant'")
        
        vc.displayedCheese = cheese.filter({vc.searchCheese(for: "Swift", on: $0)})
        
        XCTAssert(vc.displayedCheese.count == 0, "No cheese search result should contain 'Swift'")
    }
    
    /// Test where a cheese search result returns one result
    func testOneSearchResult() throws {
        let vc = AllCheeseTableViewController()
        let cheese = CanadianCheeses.allCheeses!
        
        vc.displayedCheese = cheese.filter({vc.searchCheese(for: "Purple", on: $0)})
        
        XCTAssert(vc.displayedCheese.count == 1, "Only one cheese search result should contain 'purple'")
        
        vc.displayedCheese = cheese.filter({vc.searchCheese(for: "watermelon", on: $0)})
        
        XCTAssert(vc.displayedCheese.count == 1, "Only one cheese search result should contain 'watermelon'")
    }
    
    /// Test that the cheese search results are case insensitive
    func testSearchResultCaseInsensitive() throws {
        let vc = AllCheeseTableViewController()
        let cheese = CanadianCheeses.allCheeses!
        
        let version1 = cheese.filter({vc.searchCheese(for: "Blue", on: $0)})
        let version2 = cheese.filter({vc.searchCheese(for: "BLUE", on: $0)})
        let version3 = cheese.filter({vc.searchCheese(for: "bLuE", on: $0)})
        
        XCTAssert(version1 == version2, "Search results should be case insensitive")
        XCTAssert(version2 == version3, "Search results should be case insensitive")
    }

}
