//
//  TodoItemButton.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct TodoItemButton: View {
    @Binding var isDone: Bool
    /// Called after the user changes the state, with the new value.
    var onToggle: ((Bool) -> Void)?

    var body: some View {
        Toggle("Done", isOn: Binding(
            get: { isDone },
            set: { newValue in
                isDone = newValue
                onToggle?(newValue)
            }
        ))
        .labelsHidden()
        .toggleStyle(CircleCheckToggleStyle())
    }
}

private struct CircleCheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityRepresentation { Toggle("Done", isOn: configuration.$isOn) }
    }
}

//#Preview {
//    TodoItemButton()
//}
