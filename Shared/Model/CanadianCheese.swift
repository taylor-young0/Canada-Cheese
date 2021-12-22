//
//  CanadianCheese.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import Foundation

struct CanadianCheese: Codable, Hashable {
    var cheeseId: String
    var cheeseNameEn: String
    var cheeseNameFr: String
    var manufacturerNameEn: String
    var manufacturerNameFr: String
    var manufacturerProvCode: String
    var manufacturingTypeEn: String
    var manufacturingTypeFr: String
    var websiteEn: String
    var websiteFr: String
    var fatContentPercent: String
    var moisturePercent: String
    var particularitiesEn: String
    var particularitiesFr: String
    var flavourEn: String
    var flavourFr: String
    var characteristicsEn: String
    var characteristicsFr: String
    var ripeningEn: String
    var ripeningFr: String
    var organic: String
    var categoryTypeEn: String
    var categoryTypeFr: String
    var milkTypeEn: String
    var milkTypeFr: String
    var milkTreatmentTypeEn: String
    var milkTreatmentTypeFr: String
    var rindTypeEn: String
    var rindTypeFr: String
    var lastUpdateDate: String
    
    var isOrganic: Bool {
        return self.organic == "1"
    }
    
    /// Returns the last updated date formatted nicely, removing unnecessary parts (e.g. time), and making it more human readable
    var lastUpdated: String {
        let formatter = DateFormatter()
        // 2020-03-10T14:52:18-05:00
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxx"
        
        if let date = formatter.date(from: lastUpdateDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            // note that this is also automatically localized into the current locale
            return dateFormatter.string(from: date)
        }
        
        return lastUpdateDate
    }
    
    /// Returns the proper website url for the cheese by removing any extra http://.
    /// As of July 2021 some 200+ cheese in the database have invalid urls
    /// e.g. http://http://agropur.com instead of http://agropur.com
    var websiteFixed: String {
        let locale = Bundle.main.preferredLocalizations.first
        var website: String
        
        if locale == "fr-CA" {
            website = websiteFr.isEmpty ? websiteEn : websiteFr
        } else {
            website = websiteEn.isEmpty ? websiteFr : websiteEn
        }
        
        website = website.replacingOccurrences(of: "http://https://", with: "https://")
        return website.replacingOccurrences(of: "http://http://", with: "http://")
    }
}

extension CanadianCheese {
    enum CodingKeys: String, CodingKey {
        case cheeseId = "CheeseId"
        case cheeseNameEn = "CheeseNameEn"
        case cheeseNameFr = "CheeseNameFr"
        case manufacturerNameEn = "ManufacturerNameEn"
        case manufacturerNameFr = "ManufacturerNameFr"
        case manufacturerProvCode = "ManufacturerProvCode"
        case manufacturingTypeEn = "ManufacturingTypeEn"
        case manufacturingTypeFr = "ManufacturingTypeFr"
        case websiteEn = "WebSiteEn"
        case websiteFr = "WebSiteFr"
        case fatContentPercent = "FatContentPercent"
        case moisturePercent = "MoisturePercent"
        case particularitiesEn = "ParticularitiesEn"
        case particularitiesFr = "ParticularitiesFr"
        case flavourEn = "FlavourEn"
        case flavourFr = "FlavourFr"
        case characteristicsEn = "CharacteristicsEn"
        case characteristicsFr = "CharacteristicsFr"
        case ripeningEn = "RipeningEn"
        case ripeningFr = "RipeningFr"
        case organic = "Organic"
        case categoryTypeEn = "CategoryTypeEn"
        case categoryTypeFr = "CategoryTypeFr"
        case milkTypeEn = "MilkTypeEn"
        case milkTypeFr = "MilkTypeFr"
        case milkTreatmentTypeEn = "MilkTreatmentTypeEn"
        case milkTreatmentTypeFr = "MilkTreatmentTypeFr"
        case rindTypeEn = "RindTypeEn"
        case rindTypeFr = "RindTypeFr"
        case lastUpdateDate = "LastUpdateDate"
    }
}

extension CanadianCheese {
    var isFavourite: Bool {
        return CanadianCheeses.favouriteCheeses.contains(self)
    }
}

struct CanadianCheeses: Codable {
    // all the default cheese from the JSON file
    static var allCheeses: [CanadianCheese]?
    // the ids of the favourite cheese, this is what is written to UserDefaults
    static var favouriteCheesesIDs = [String]()
    // the favourite cheese
    static var favouriteCheeses = [CanadianCheese]()
    var cheeseDirectory: [CanadianCheese]
    
    enum CodingKeys: String, CodingKey {
        case cheeseDirectory = "CheeseDirectory"
    }
}
