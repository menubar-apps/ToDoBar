//
//  NewTodoField.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct NewTodoField: View {
    @Binding var newTodo: String
    @FocusState.Binding var isTextFieldFocused: Bool
    var onAddTodo: () -> Void
    
    var body: some View {
        HStack {
            TextField("Type a task and hit enter", text: $newTodo)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .padding(.leading, 22)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isTextFieldFocused)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(NSColor.textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                        .accessibilityHidden(true)
                )
                .onSubmit(onAddTodo)
                .onAppear {
                    isTextFieldFocused = true
                }
            
            Spacer()
        }
    }
}


//#Preview {
//    NewTodoField()
//}
