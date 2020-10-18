//
//  SystemSmallView.swift
//  nasaAPIWidgetExtension
//
//  Created by Nick Viscomi on 10/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SystemSmallView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image(uiImage: (entry.model.image))
                .resizable()
            
            VStack {
                Text(entry.model.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(Color(.secondarySystemBackground).opacity(0.65))
                    .foregroundColor(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
        }
    }
}


struct SystemSmallView_Previews: PreviewProvider {
    static var previews: some View {
        let model = WidgetModel(date: "2020-10-15", title: "Young Stars in the Ophiuch Cloud", image: UIImage(named: "photo2")!)
        
        nasaAPIWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: model))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
