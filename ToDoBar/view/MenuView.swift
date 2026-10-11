//
//  MenuView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI
import LaunchAtLogin
import Defaults
import KeyboardShortcuts

struct MenuView: View {
    @Binding var todos: [Todo]
    @Default(.showTaskCount) var showTaskCount
    @Environment(\.openURL) private var openURL

    var body: some View {
        Menu {
            Button(action: {
                todos = todos.filter{ !$0.isDone }
            }) {
                Label("Clear Done", systemImage: "checkmark.circle")
            }
            Button(action: confirmClearAll) {
                Label("Clear All", systemImage: "trash")
            }
            Divider()
            LaunchAtLogin.Toggle()
            Toggle("Show Task Count", isOn: $showTaskCount)
            Button(action: { (NSApplication.shared.delegate as? AppDelegate)?.openShortcutWindow() }) {
                let shortcut = KeyboardShortcuts.getShortcut(for: .toggleTodoList)?.description ?? "–"
                Label("Keyboard Shortcut: \(shortcut)", systemImage: "keyboard")
            }
            Divider()
            // Only in the GitHub build. Build with DISTRIBUTION_FLAG=DIRECT_DISTRIBUTION.
            #if DIRECT_DISTRIBUTION
            Button(action: { openURL(URL("https://buymeacoffee.com/streetturtle")) }) {
                Label("Buy Me a Coffee", systemImage: "cup.and.saucer.fill")
            }
            #endif
            Button(action: { (NSApplication.shared.delegate as? AppDelegate)?.openAboutWindow(nil) } ) {
                Label("About ToDoBar", systemImage: "info.circle")
            }
            Button(action: { (NSApplication.shared.delegate as? AppDelegate)?.quit() }) {
                Label("Quit", systemImage: "power")
            }
        } label: {
            // Size, background and hit area live in the label so the whole box opens the menu.
            Image(systemName: "chevron.down")
                .frame(width: 32, height: 32)
                .background(Color.accentColor)
                .cornerRadius(8)
                .contentShape(Rectangle())
        }
        .labelsHidden()
        .menuStyle(.button)
        .buttonStyle(.plain)
        .menuIndicator(.hidden)
        .fixedSize()
        .accessibilityLabel(Text("Menu"))
    }

    private func confirmClearAll() {
        guard !todos.isEmpty else { return }
        let alert = NSAlert()
        alert.messageText = String(localized: "Clear all tasks?")
        alert.informativeText = String(localized: "This removes every task, including unfinished ones.")
        alert.addButton(withTitle: String(localized: "Clear All"))
        alert.addButton(withTitle: String(localized: "Cancel"))
        if alert.runModal() == .alertFirstButtonReturn {
            todos.removeAll()
        }
    }
}

//#Preview {
//    MenuView()
//}
