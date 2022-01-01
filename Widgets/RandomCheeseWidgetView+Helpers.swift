//
//  RandomCheeseWidgetView+Helpers.swift
//  WidgetsExtension
//
//  Created by Taylor Young on 2022-01-01.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import SwiftUI

extension RandomCheeseWidgetView {
    /// Textual description of cheese, try flavour, then characteristics, then particularities, then cheese type
    /// NOTE: Returns `-` if all are still empty
    var cheeseDescription: String {
        var desc = propertyValue("Flavour", on: entry.cheese!, inLocale: entry.locale)
        
        // if cheese has no flavour listed try characteristics
        if desc == "-" {
            desc = propertyValue("Characteristics", on: entry.cheese!, inLocale: entry.locale)
        }
        
        // if no characteristics try particularities
        if desc == "-" {
            desc = propertyValue("Particularities", on: entry.cheese!, inLocale: entry.locale)
        }
        
        // if no particularities try cheese type
        if desc == "-" {
            desc = propertyValue("Cheese type", on: entry.cheese!, inLocale: entry.locale)
        }
        
        // return the description, still could be a dash `-`
        return desc
    }
    
    func propertyValue(_ property: String, on cheese: CanadianCheese, inLocale locale: String) -> String {
        var value = ""
        // if French (Canada), prefer French before English values
        if locale == "fr-CA" {
            switch property {
            case "Cheese":
                value = cheese.cheeseNameFr != "" ? cheese.cheeseNameFr : cheese.cheeseNameEn
            case "Manufacturer":
                value = cheese.manufacturerNameFr != "" ? cheese.manufacturerNameFr : cheese.manufacturerNameEn
            case "Manufacturer province":
                value = cheese.manufacturerProvCode
            case "Manufacturing type":
                value = cheese.manufacturingTypeFr != "" ? cheese.manufacturingTypeFr : cheese.manufacturingTypeEn
            case "Website":
                value = cheese.websiteFixed
            case "Fat":
                // no fat % given? Don't display the percentage sign!
                value = cheese.fatContentPercent != "" ? "\(cheese.fatContentPercent)%" : ""
            case "Moisture":
                // no moisture % given? Don't display the percentage sign!
                value = cheese.moisturePercent != "" ? "\(cheese.moisturePercent)%" : ""
            case "Particularities":
                value = cheese.particularitiesFr != "" ? cheese.particularitiesFr : cheese.particularitiesEn
            case "Flavour":
                value = cheese.flavourFr != "" ? cheese.flavourFr : cheese.flavourEn
            case "Characteristics":
                value = cheese.characteristicsFr != "" ? cheese.characteristicsFr : cheese.characteristicsEn
            case "Ripening":
                value = cheese.ripeningFr != "" ? cheese.ripeningFr : cheese.ripeningEn
            case "Organic":
                value = (cheese.organic == "1" ? NSLocalizedString("Organic", tableName: nil, bundle: bundle, value: "", comment: "") : NSLocalizedString("Non-organic", tableName: nil, bundle: bundle, value: "", comment: ""))
            case "Cheese type":
                value = cheese.categoryTypeFr != "" ? cheese.categoryTypeFr : cheese.categoryTypeEn
            case "Milk type":
                value = cheese.milkTypeFr != "" ? cheese.milkTypeFr : cheese.milkTypeEn
            case "Milk treatment":
                value = cheese.milkTreatmentTypeFr != "" ? cheese.milkTreatmentTypeFr : cheese.milkTreatmentTypeEn
            case "Rind type":
                value = cheese.rindTypeFr != "" ? cheese.rindTypeFr : cheese.rindTypeEn
            case "Last update":
                value = cheese.lastUpdated
            default:
                value = ""
            }
        } else {
            // assume user wants English, if not present we display French
            // Note that this can still result in empty Strings being returned if neither French nor English have text values
            switch property {
            case "Cheese":
                value = cheese.cheeseNameEn != "" ? cheese.cheeseNameEn : cheese.cheeseNameFr
            case "Manufacturer":
                value = cheese.manufacturerNameEn != "" ? cheese.manufacturerNameEn : cheese.manufacturerNameFr
            case "Manufacturer province":
                value = cheese.manufacturerProvCode
            case "Manufacturing type":
                value = cheese.manufacturingTypeEn != "" ? cheese.manufacturingTypeEn : cheese.manufacturingTypeFr
            case "Website":
                value = cheese.websiteFixed
            case "Fat":
                // no fat % given? Don't display the percentage sign!
                value = cheese.fatContentPercent != "" ? "\(cheese.fatContentPercent)%" : ""
            case "Moisture":
                // no moisture % given? Don't display the percentage sign!
                value = cheese.moisturePercent != "" ? "\(cheese.moisturePercent)%" : ""
            case "Particularities":
                value = cheese.particularitiesEn != "" ? cheese.particularitiesEn : cheese.particularitiesFr
            case "Flavour":
                value = cheese.flavourEn != "" ? cheese.flavourEn : cheese.flavourFr
            case "Characteristics":
                value = cheese.characteristicsEn != "" ? cheese.characteristicsEn : cheese.characteristicsFr
            case "Ripening":
                value = cheese.ripeningEn != "" ? cheese.ripeningEn : cheese.ripeningFr
            case "Organic":
                value = (cheese.organic == "1" ? NSLocalizedString("Organic", tableName: nil, bundle: bundle, value: "", comment: "") : NSLocalizedString("Non-organic", tableName: nil, bundle: bundle, value: "", comment: ""))
            case "Cheese type":
                value = cheese.categoryTypeEn != "" ? cheese.categoryTypeEn : cheese.categoryTypeFr
            case "Milk type":
                value = cheese.milkTypeEn != "" ? cheese.milkTypeEn : cheese.milkTypeFr
            case "Milk treatment":
                value = cheese.milkTreatmentTypeEn != "" ? cheese.milkTreatmentTypeEn : cheese.milkTreatmentTypeFr
            case "Rind type":
                value = cheese.rindTypeEn != "" ? cheese.rindTypeEn : cheese.rindTypeFr
            case "Last update":
                value = cheese.lastUpdated
            default:
                value = ""
            }
        }
        
        return value.isEmpty ? "-" : value
    }
}

