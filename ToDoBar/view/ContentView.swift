//
//  ContentView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import SwiftUI
import Defaults
import StoreKit

struct ContentView: View {

    @Default(.todos) var todos
    @Environment(\.requestReview) private var requestReview

    @State private var editedItem: String = ""
    @State private var newTodo: String = ""
    @State private var editedItemID: Todo.ID?

    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isTodoItemFocused: Bool

    var body: some View {
        VStack {
            TodoList(
                todos: $todos,
                editedItemID: $editedItemID,
                isTodoItemFocused: $isTodoItemFocused,
                editedItem: $editedItem,
                onCompletionChanged: completionChanged
            )
            .scrollContentBackground(.hidden)

            HStack {
                NewTodoField(
                    newTodo: $newTodo,
                    isTextFieldFocused: $isTextFieldFocused,
                    onAddTodo: {
                        if todos.add(text: newTodo) {
                            newTodo = ""
                        }
                    }
                )
                
                Spacer()
                
                MenuView(todos: $todos)
            }
            .padding(8)
        }
        // Focus the new-task field every time the popover opens, not only the first time.
        .onReceive(NotificationCenter.default.publisher(for: NSPopover.willShowNotification)) { _ in
            editedItemID = nil
            isTextFieldFocused = true
        }
    }

    private func completionChanged(isDone: Bool) {
        if isDone {
            Defaults[.completedCount] += 1
            if ReviewPrompt.shouldRequest(completedCount: Defaults[.completedCount]) {
                requestReview()
            }
        } else {
            // Unmarking undoes the count so ticking and unticking can't trigger the prompt.
            Defaults[.completedCount] = max(0, Defaults[.completedCount] - 1)
        }
    }
}
