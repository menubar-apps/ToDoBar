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
            Button(action: {
                openURL(URL(string:"https://github.com/menubar-apps/ToDoBar/issues/new?template=feature_request.md")!)
            }) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Request a Feature")
                }
                .frame(maxWidth: 160)
            }
            Button(action: {
                openURL(URL(string:"https://github.com/menubar-apps/ToDoBar/issues/new?template=bug_report.md")!)
            }) {
                HStack {
                    Image(systemName: "ladybug.fill")
                    Text("Report a Bug")
                }
                .frame(maxWidth: 160)
            }
        }.padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
