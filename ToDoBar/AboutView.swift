//
//  AboutView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2023-07-07.
//

import SwiftUI

struct AboutView: View {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
            Text("ToDoBar").font(.title)
            Text("by Pavel Makhov").font(.caption)
            Text("version " + currentVersion).font(.footnote)
            Divider()
            Link("ToDoBar on GitHub", destination: URL(string: "https://github.com/menubar-apps/ToDoBar")!)
            
        }.padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
