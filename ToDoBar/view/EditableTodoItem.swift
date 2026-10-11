//
//  EditableTodoItem.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct EditableTodoItem: View {
    @Binding var editedItem: String
    @FocusState.Binding var isTodoItemFocused: Bool

    var onSubmit: () -> Void
    var onExit: () -> Void
    var onFocusChange: (Bool) -> Void
    
    var body: some View {
        TextField("", text: $editedItem, axis: .vertical)
            .focused($isTodoItemFocused)
            .onSubmit(onSubmit)
            .onExitCommand(perform: onExit)
            .onChange(of: isTodoItemFocused, perform: onFocusChange)
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .accessibilityLabel(Text("Edit task"))
    }
}


// Preview
struct EditableTodoItem_Previews: PreviewProvider {
    @State static var editedItem = "Sample Todo Item"
    @FocusState static var isTodoItemFocused: Bool
    
    static var previews: some View {
        EditableTodoItem(
            editedItem: $editedItem,
            isTodoItemFocused: $isTodoItemFocused,
            onSubmit: {
                print("Submitted: \(editedItem)")
            },
            onExit: {
                print("Exited: \(editedItem)")
            },
            onFocusChange: { isFocused in
                print("Focus changed: \(isFocused)")
            }
        )
        .padding()
//        .previewLayout(.sizeThatFits)
    }
}
