//
//  ShortcutView.swift
//  ToDoBar
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Open ToDoBar from anywhere")
            KeyboardShortcuts.Recorder(for: .toggleTodoList)
        }
        .padding(20)
    }
}
