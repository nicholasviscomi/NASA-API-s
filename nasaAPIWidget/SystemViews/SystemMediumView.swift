//
//  SystemMediumView.swift
//  nasaAPIWidgetExtension
//
//  Created by Nick Viscomi on 10/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SystemMediumView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            
            Image(uiImage: (entry.model.image))
                .resizable()
            
            ZStack {
                HStack(alignment: .center, spacing: nil) {
                    Text(entry.model.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                        .background(Color(.secondarySystemBackground).opacity(0.45))
                        .foregroundColor(Color(.secondarySystemBackground))
                        .cornerRadius(15)
                    
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                        .background(Color(.label).opacity(0.45))
                        .foregroundColor(Color(.secondarySystemBackground))
                        .cornerRadius(15)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(Color(.tertiarySystemBackground).opacity(0.6))
                .foregroundColor(Color(.tertiarySystemBackground))
                .cornerRadius(15)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        
    }
}




struct SystemMediumView_Previews: PreviewProvider {
    static var previews: some View {
        let model = WidgetModel(date: "2020-10-15", title: "Young Stars in the Ophiuch Cloud", image: UIImage(named: "photo2")!)
        
        nasaAPIWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: model))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)
    }
}
