//
//  AppPromotionView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct AppPromotionView: View {
    let apps: [PromoApp] = [
        PromoApp(name: "GojiBar",
                 iconName: "gojibar",
                 appStoreURL: URL("https://apps.apple.com/app/id6471348025")),
        PromoApp(name: "OctoSpace",
                 iconName: "octospace",
                 appStoreURL: URL("https://apps.apple.com/app/id6473707939")),
        PromoApp(name: "PullBar Pro",
                 iconName: "pullbarpro",
                 appStoreURL: URL("https://apps.apple.com/app/id6462591649")),
        PromoApp(name: "StreakBar",
                 iconName: "streakbar",
                 appStoreURL: URL("https://apps.apple.com/app/id6464448808")),
    ]
    
    var body: some View {
        Text("More apps")
            .font(.headline)
        
        HStack {
            ForEach(apps, id:\.id) { app in
                AppView(app: app)
            }
            
        }
    }
}

#Preview {
    AppPromotionView()
}
