//
//  CanadianCheese.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import Foundation

struct CanadianCheese: Codable, Hashable {
    var CheeseId: String
    var CheeseNameEn: String
    var CheeseNameFr: String
    var ManufacturerNameEn: String
    var ManufacturerNameFr: String
    var ManufacturerProvCode: String
    var ManufacturingTypeEn: String
    var ManufacturingTypeFr: String
    var WebSiteEn: String
    var WebSiteFr: String
    var FatContentPercent: String
    var MoisturePercent: String
    var ParticularitiesEn: String
    var ParticularitiesFr: String
    var FlavourEn: String
    var FlavourFr: String
    var CharacteristicsEn: String
    var CharacteristicsFr: String
    var RipeningEn: String
    var RipeningFr: String
    var Organic: String
    var CategoryTypeEn: String
    var CategoryTypeFr: String
    var MilkTypeEn: String
    var MilkTypeFr: String
    var MilkTreatmentTypeEn: String
    var MilkTreatmentTypeFr: String
    var RindTypeEn: String
    var RindTypeFr: String
    var LastUpdateDate: String
    
    var isOrganic: Bool {
        return self.Organic == "1"
    }
}

extension CanadianCheese {
    var isFavourite: Bool {
        return CanadianCheeses.favouriteCheeses.contains(self)
    }
}

struct CanadianCheeses: Codable {
    static var allCheeses: [CanadianCheese]?
    static var favouriteCheesesIDs = [String]()
    static var favouriteCheeses = [CanadianCheese]()
    var CheeseDirectory: [CanadianCheese]
}
