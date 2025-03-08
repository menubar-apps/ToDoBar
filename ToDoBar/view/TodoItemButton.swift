//
//  TodoItemButton.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct TodoItemButton: View {
    @Binding var isDone: Bool
    
    var body: some View {
        Button(action: {
            isDone.toggle()
        }) {
            Image(systemName: isDone ? "checkmark.circle" : "circle")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.top, 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    TodoItemButton()
//}
