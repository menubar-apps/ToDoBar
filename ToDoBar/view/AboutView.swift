//
//  AboutView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2023-07-07.
//

import SwiftUI

struct AboutView: View {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    @Environment(\.openURL) var openURL
    
    var body: some View {

        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
            Text("ToDoBar").font(.title)
            Text("by Pavel Makhov").font(.caption)
            Text("version " + currentVersion).font(.footnote)
            Divider()
            Button(action: {
                openURL(URL(string:"https://menubar-apps.github.io/#todobar")!)
            }) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("Home Page")
                }
                .frame(maxWidth: 160)
                
            }
            .buttonStyle(.borderless)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            
            Button(action: {
                openURL(URL(string:"https://github.com/menubar-apps/ToDoBar/issues/new?template=feature_request.md")!)
            }) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Request a Feature")
                }
                .frame(maxWidth: 160)
            }
            .buttonStyle(.borderless)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            
            Button(action: {
                openURL(URL(string:"https://github.com/menubar-apps/ToDoBar/issues/new?template=bug_report.md")!)
            }) {
                HStack {
                    Image(systemName: "ladybug.fill")
                    Text("Report a Bug")
                }
                .frame(maxWidth: 160)
            }
            .buttonStyle(.borderless)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            
            Divider()
            AppPromotionView()
        }.padding()
        
        
    }
}

struct App: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let appStoreURL: String
}

#Preview {
    AboutView()
        .frame(height: 500)
}
