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
    
    let cheese = Widgets_Previews.cheese
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, cheese: cheese)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
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

@main
struct Widgets: Widget {
    let kind: String = "Random Cheese"
    
    var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 15.0, *) {
            return [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
        } else {
            return [.systemSmall, .systemMedium, .systemLarge]
        }
    }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RandomCheeseWidgetView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("Random cheese", comment: ""))
        .description(NSLocalizedString("Showcases a random cheese.", comment: ""))
        .supportedFamilies(supportedFamilies)
    }
}

struct Widgets_Previews: PreviewProvider {
    static let cheese = CanadianCheese(cheeseId: "374",
                                       cheeseNameEn: "Goat Brie (Woolwich)",
                                       cheeseNameFr: "",
                                       manufacturerNameEn: "Woolwich Dairy",
                                       manufacturerNameFr: "",
                                       manufacturerProvCode: "ON",
                                       manufacturingTypeEn: "Industrial",
                                       manufacturingTypeFr: "Industrielle",
                                       websiteEn: "http://www.woolwichdairy.com",
                                       websiteFr: "http://www.woolwichdairy.com/french.aspx",
                                       fatContentPercent: "22",
                                       moisturePercent: "52",
                                       particularitiesEn: "Rennet free, ripens from the outside in",
                                       particularitiesFr: "Sans présure, affiné en surface",
                                       flavourEn: "Rich, creamy, buttery, both subtle and tangy in taste",
                                       flavourFr: "Riche, crèmeuse, butyreuse, goût doux et piquant",
                                       characteristicsEn: "",
                                       characteristicsFr: "",
                                       ripeningEn: "Less than 1 Month",
                                       ripeningFr: "moins de 1 mois",
                                       organic: "0",
                                       categoryTypeEn: "Soft Cheese",
                                       categoryTypeFr: "Pâte molle",
                                       milkTypeEn: "Goat",
                                       milkTypeFr: "Chèvre",
                                       milkTreatmentTypeEn: "Pasteurized",
                                       milkTreatmentTypeFr: "Pasteurisé",
                                       rindTypeEn: "Bloomy Rind",
                                       rindTypeFr: "Croûte fleurie",
                                       lastUpdateDate: "2016-02-03T11:04:25-05:00")
    
    static var previews: some View {
        
        // MARK: systemSmall
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDevice("iPhone 8")
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDevice("iPhone 12")
        
        // MARK: systemMedium
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDevice("iPhone 8")
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDevice("iPhone 12")
        
        // MARK: systemLarge
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDevice("iPhone 8")
        
        RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDevice("iPhone 12")
        
        // MARK: systemExtraLarge

        if #available(iOSApplicationExtension 15.0, *) {
            RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
                .previewDevice("iPad (9th generation)")
            
            RandomCheeseWidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cheese: cheese))
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}
