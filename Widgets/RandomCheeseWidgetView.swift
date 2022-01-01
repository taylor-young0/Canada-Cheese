//
//  RandomCheeseWidgetView.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2022-01-01.
//  Copyright © 2022 Taylor Young. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RandomCheeseWidgetView : View {
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
        }
    }
}

struct RandomCheeseWidgetView_Previews: PreviewProvider {
    static let cheese = Widgets_Previews.cheese
    
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
