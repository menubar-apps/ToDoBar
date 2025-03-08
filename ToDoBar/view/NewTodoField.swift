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
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isTextFieldFocused)
                .focusable(true) { isFocused in
                    self.isTextFieldFocused = isFocused
                }
                .overlay(
                    Image(systemName: "plus.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
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
