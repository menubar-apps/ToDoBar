//
//  MenuView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI
import LaunchAtLogin

struct MenuView: View {
    @Binding var todos: [Todo]
    var appDelegate: AppDelegate
    
    var body: some View {
        Menu {
            Button(action: {
                todos = todos.filter{ !$0.isDone }
            }) {
                Label("Clear Done", systemImage: "eyeglasses")
            }
            Button(action: {
                todos.removeAll()
            }) {
                Label("Clear All", systemImage: "book")
            }
            Divider()
            LaunchAtLogin.Toggle()
            Divider()
            Button(action: { appDelegate.openAboutWindow(nil) } ) {
                Label("About ToDoBar", systemImage: "books.vertical")
            }
            Button(action: { appDelegate.quit() }) {
                Label("Quit", systemImage: "books.vertical")
            }
        } label: {
            Image(systemName: "chevron.down")
        }
        .labelsHidden()
        .scaledToFit()
        .menuStyle(BorderlessButtonMenuStyle())
        .menuIndicator(.hidden)
        .frame(width: 16, height: 16)
        .padding(.vertical, 8)
        .padding(.leading, 10)
        .padding(.trailing, 6)
        .background(Color.accentColor)
        .cornerRadius(8)
        .contentShape(Rectangle())
    }
}

//#Preview {
//    MenuView()
//}
