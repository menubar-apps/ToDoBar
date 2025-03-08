//
//  AppPromotionView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct AppPromotionView: View {
    let apps: [App] = [
        App(name: "GojiBar",
            description: "Description for App One",
            iconName: "gojibar",
            appStoreURL: "https://apps.apple.com/app/id6471348025"),
        App(name: "OctoSpace",
            description: "Description for App Two",
            iconName: "octospace",
            appStoreURL: "https://apps.apple.com/app/id6473707939"),
        App(name: "PullBar Pro",
            description: "Description for App Three",
            iconName: "pullbarpro",
            appStoreURL: "https://apps.apple.com/app/id6462591649"),
        App(name: "StreakBar",
            description: "Description for App Four",
            iconName: "streakbar",
            appStoreURL: "https://apps.apple.com/app/id6464448808"),
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
