//
//  TodoItemView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct TodoItemView: View {
    let text: String
    let isDone: Bool
    
    var onTap: () -> Void
    var onHover: (Bool) -> Void
    
    var body: some View {
        Text(text)
            .foregroundColor(isDone ? .secondary : .primary)
            .padding(2)
            .strikethrough(isDone)
            .onTapGesture(perform: onTap)
            .onHover(perform: onHover)
    }
}

//#Preview {
//    TodoItemView(text: "asd", isDone: false, onTap: nil, onnil)
//}
