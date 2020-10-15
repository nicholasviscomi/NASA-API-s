//
//  nasaAPIWidget.swift
//  nasaAPIWidget
//
//  Created by Nick Viscomi on 10/13/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: WidgetModel(date: "", title: "", image: UIImage(named: "Image")!))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, model: WidgetModel(date: "2020-10-15", title: "Today", image: UIImage(named: "photo2")!))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
        let APICalls = WidgetAPI()
        
        APICalls.getCurrentWidgetModel { (model) in
            if let model = model {
                let entry = SimpleEntry(date: Date(), configuration: configuration, model: model)
//                entries.append(entry)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            } else {
                let entry = SimpleEntry(date: Date(), configuration: configuration, model: WidgetModel(date: "2020-10-15", title: "Today", image: UIImage(named: "photo2")!))
//                entries.append(entry)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
        
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let model: WidgetModel
}

struct nasaAPIWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        MainView(entry: entry)
    }
}

struct MainView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image(uiImage: (entry.model.image))
                .resizable()
            
            VStack {
                Text(entry.model.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(Color(.secondarySystemBackground).opacity(0.65))
                    .foregroundColor(Color(.secondarySystemBackground))
                    .cornerRadius(15)

                    
//                Text(Date(), style: .date)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .lineLimit(0)
            }
            
        }
    }
}

@main
struct nasaAPIWidget: Widget {
    let kind: String = "nasaAPIWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            nasaAPIWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}



struct nasaAPIWidget_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = WidgetModel(date: "2020-10-15", title: "Young Stars in the Ophiuch Cloud", image: UIImage(named: "photo2")!)
        Group {
            nasaAPIWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: model))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            nasaAPIWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: model))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.colorScheme, .dark)
        }
    }
}
