//
//  Widgets.swift
//  Widgets
//
//  Created by Taylor Young on 2021-12-16.
//  Copyright © 2021 Taylor Young. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    let cheese = CanadianCheese(cheeseId: "374", cheeseNameEn: "Goat Brie (Woolwich)", cheeseNameFr: "", manufacturerNameEn: "Woolwich Dairy", manufacturerNameFr: "", manufacturerProvCode: "ON", manufacturingTypeEn: "Industrial", manufacturingTypeFr: "Industrielle", websiteEn: "http://www.woolwichdairy.com", websiteFr: "http://www.woolwichdairy.com/french.aspx", fatContentPercent: "22", moisturePercent: "52", particularitiesEn: "Rennet free, ripens from the outside in", particularitiesFr: "Sans présure, affiné en surface", flavourEn: "Rich, creamy, buttery, both subtle and tangy in taste", flavourFr: "Riche, crèmeuse, butyreuse, goût doux et piquant", characteristicsEn: "", characteristicsFr: "", ripeningEn: "Less than 1 Month", ripeningFr: "moins de 1 mois", organic: "0", categoryTypeEn: "Soft Cheese", categoryTypeFr: "Pâte molle", milkTypeEn: "Goat", milkTypeFr: "Chèvre", milkTreatmentTypeEn: "Pasteurized", milkTreatmentTypeFr: "Pasteurisé", rindTypeEn: "Bloomy Rind", rindTypeFr: "Croûte fleurie", lastUpdateDate: "2016-02-03T11:04:25-05:00")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, cheese: cheese)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // fetch random cheese to feature, filter by type if user configured to
        var allCheeses = fetchAllCheese()
        
        if configuration.cheeseType != .all && configuration.cheeseType != .unknown {
            var cheeseType: String
            
            switch(configuration.cheeseType) {
            case .softCheese:
                cheeseType = "Soft Cheese"
            case .semiSoftCheese:
                cheeseType = "Semi-soft Cheese"
            case .firmCheese:
                cheeseType = "Firm Cheese"
            case .hardCheese:
                cheeseType = "Hard Cheese"
            case .veinedCheese:
                cheeseType = "Veined Cheeses"
            case .freshCheese:
                cheeseType = "Fresh Cheese"
            default:
                cheeseType = "Soft Cheese"
            }
            
            // Filter for those types of cheese
            allCheeses = allCheeses.filter {
                $0.categoryTypeEn == cheeseType
            }
        }
        
        let cheese = allCheeses.randomElement()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, cheese: cheese)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func fetchAllCheese() -> [CanadianCheese] {
        // Load the JSON data
        let urlString = "https://od-do.agr.gc.ca/canadianCheeseDirectory.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                return parse(json: data)
            } else {
                print("error")
            }
        }
        return [CanadianCheese]()
    }
    
    func parse(json: Data) -> [CanadianCheese] {
        let decoder = JSONDecoder()
        
        if let jsonCheese = try? decoder.decode(CanadianCheeses.self, from: json) {
           return jsonCheese.cheeseDirectory
        }
        return [CanadianCheese]()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let cheese: CanadianCheese?
    let locale = Bundle.init(identifier: "io.github.taylor-young0.Canada-Cheese")?.preferredLocalizations.first ?? ""
}

struct WidgetsEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    // Bundle needed for fetching main app localization file
    // Note that there are two `Localizable.strings` for used in this Widget
    let bundle = Bundle.init(identifier: "io.github.taylor-young0.Canada-Cheese")!

    // MARK: body
    
    @ViewBuilder
    var body: some View {
        switch(family) {
        case .systemSmall:
            small
        case .systemMedium:
            medium
        case .systemLarge:
            large
        case .systemExtraLarge:
            extraLarge
        @unknown default:
            small
        }
    
    }
    
    // MARK: small
    
    var small: some View {
        HStack {
            cheeseHeader
                .padding()
            Spacer()
        }
        .widgetURL(URL(string: "canadacheese:cheese?id=\(entry.cheese!.cheeseId)"))
    }
    
    // MARK: medium
    
    var medium: some View {
        HStack {
            VStack(alignment: .leading) {
                cheeseHeader
                    .padding(.bottom)
                    
                Text(cheeseDescription)
                    .lineLimit(3)
            }
            .padding()
            Spacer()
        }
        .widgetURL(URL(string: "canadacheese:cheese?id=\(entry.cheese!.cheeseId)"))
    }
    
    // MARK: large
    
    var large: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Random cheese", comment: "").uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                Text(propertyValue("Cheese", on: entry.cheese!, inLocale: entry.locale))
                    .fontWeight(.bold)
                    .lineLimit(3)
                Text(propertyValue("Manufacturer", on: entry.cheese!, inLocale: entry.locale))
                    .lineLimit(3)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                largeInformation
            }
            .padding()
            Spacer()
        }
        .widgetURL(URL(string: "canadacheese:cheese?id=\(entry.cheese!.cheeseId)"))
    }
    
    // MARK: extraLarge
    
    var extraLarge: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Random cheese", comment: "").uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                Text(propertyValue("Cheese", on: entry.cheese!, inLocale: entry.locale))
                    .fontWeight(.bold)
                    .lineLimit(3)
                Text(propertyValue("Manufacturer", on: entry.cheese!, inLocale: entry.locale))
                    .lineLimit(3)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                HStack {
                    extraLargeColumnOne
                    extraLargeColumnTwo
                }
            }
            .padding()
            Spacer()
        }
        .widgetURL(URL(string: "canadacheese:cheese?id=\(entry.cheese!.cheeseId)"))
    }
    
    var cheeseHeader: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Random cheese", comment: "").uppercased())
                .font(.caption.bold())
                .foregroundColor(.orange)
            Text(propertyValue("Cheese", on: entry.cheese!, inLocale: entry.locale))
                .fontWeight(.bold)
                .lineLimit(3)
            Text(propertyValue("Manufacturer", on: entry.cheese!, inLocale: entry.locale))
                .lineLimit(3)
                .foregroundColor(.gray)
        }
    }
    
    var largeInformation: some View {
        Group {
            Text(cheeseDescription)
                .lineLimit(3)
            Divider()
            HStack {
                Text(NSLocalizedString("Cheese type", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Cheese type", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Milk type", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Milk type", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Manufacturer province", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Manufacturer province", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
        }
    }
    
    var extraLargeColumnOne: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Particularities", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Particularities", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Flavour", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Flavour", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Characteristics", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Characteristics", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Manufacturer province", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Manufacturer province", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            Spacer()
        }
    }
    
    var extraLargeColumnTwo: some View {
        VStack {
            Group {
                HStack {
                    Text(NSLocalizedString("Ripening", tableName: nil, bundle: bundle, value: "", comment: ""))
                    Spacer()
                    Text(propertyValue("Ripening", on: entry.cheese!, inLocale: entry.locale))
                        .foregroundColor(.gray)
                }
                Divider()
                HStack {
                    Text(NSLocalizedString("Organic", tableName: nil, bundle: bundle, value: "", comment: ""))
                    Spacer()
                    Text(propertyValue("Organic", on: entry.cheese!, inLocale: entry.locale))
                        .foregroundColor(.gray)
                }
                Divider()
                HStack {
                    Text(NSLocalizedString("Cheese type", tableName: nil, bundle: bundle, value: "", comment: ""))
                    Spacer()
                    Text(propertyValue("Cheese type", on: entry.cheese!, inLocale: entry.locale))
                        .foregroundColor(.gray)
                }
                Divider()
                HStack {
                    Text(NSLocalizedString("Milk type", tableName: nil, bundle: bundle, value: "", comment: ""))
                    Spacer()
                    Text(propertyValue("Milk type", on: entry.cheese!, inLocale: entry.locale))
                        .foregroundColor(.gray)
                }
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Milk treatment", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Milk treatment", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            HStack {
                Text(NSLocalizedString("Rind type", tableName: nil, bundle: bundle, value: "", comment: ""))
                Spacer()
                Text(propertyValue("Rind type", on: entry.cheese!, inLocale: entry.locale))
                    .foregroundColor(.gray)
            }
            Divider()
            Spacer()
        }
    }
    
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

@main
struct Widgets: Widget {
    let kind: String = "Random Cheese"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("Random cheese", comment: ""))
        .description(NSLocalizedString("Showcases a random cheese.", comment: ""))
    }
}

struct Widgets_Previews: PreviewProvider {
    static let cheese = CanadianCheese(cheeseId: "374", cheeseNameEn: "Goat Brie (Woolwich)", cheeseNameFr: "", manufacturerNameEn: "Woolwich Dairy", manufacturerNameFr: "", manufacturerProvCode: "ON", manufacturingTypeEn: "Industrial", manufacturingTypeFr: "Industrielle", websiteEn: "http://www.woolwichdairy.com", websiteFr: "http://www.woolwichdairy.com/french.aspx", fatContentPercent: "22", moisturePercent: "52", particularitiesEn: "Rennet free, ripens from the outside in", particularitiesFr: "Sans présure, affiné en surface", flavourEn: "Rich, creamy, buttery, both subtle and tangy in taste", flavourFr: "Riche, crèmeuse, butyreuse, goût doux et piquant", characteristicsEn: "", characteristicsFr: "", ripeningEn: "Less than 1 Month", ripeningFr: "moins de 1 mois", organic: "0", categoryTypeEn: "Soft Cheese", categoryTypeFr: "Pâte molle", milkTypeEn: "Goat", milkTypeFr: "Chèvre", milkTreatmentTypeEn: "Pasteurized", milkTreatmentTypeFr: "Pasteurisé", rindTypeEn: "Bloomy Rind", rindTypeFr: "Croûte fleurie", lastUpdateDate: "2016-02-03T11:04:25-05:00")
    
    static var previews: some View {
        
        // MARK: systemSmall
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDevice("iPhone 8")
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDevice("iPhone 12")
        
        // MARK: systemMedium
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDevice("iPhone 8")
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDevice("iPhone 12")
        
        // MARK: systemLarge
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDevice("iPhone 8")
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDevice("iPhone 12")
        
        // MARK: systemExtraLarge
        
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
