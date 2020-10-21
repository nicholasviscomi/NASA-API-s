//
//  SystemLargeView.swift
//  nasaAPIWidgetExtension
//
//  Created by Nick Viscomi on 10/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SystemLargeView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image(uiImage: (entry.model.image))
                .resizable()
            
            VStack(spacing: 0) {
                Rectangle()
                    .opacity(0)
                Rectangle()
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            
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

struct SystemLargeView_Previews: PreviewProvider {
    static var previews: some View {
        let model = WidgetModel(date: "2020-10-15", title: "Young Stars in the Ophiuch Cloud", image: UIImage(named: "photo2")!)
        
        nasaAPIWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: model))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
                                
    }
}
