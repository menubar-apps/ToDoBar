//
//  TodoList.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct TodoList: View {
    @Binding var todos: [Todo]
    @Binding var editedItemID: Todo.ID?

    @FocusState.Binding var isTodoItemFocused: Bool
    @Binding var editedItem: String
    /// Called with `true` when a task is marked done and `false` when it is unmarked.
    var onCompletionChanged: (Bool) -> Void

    var body: some View {
        List {
            ForEach($todos) { $todo in
                let id = todo.id
                HStack {
                    ReorderButton()

                    TodoItemButton(isDone: $todo.isDone, onToggle: onCompletionChanged)

                    if editedItemID == id {
                        EditableTodoItem(
                            editedItem: $editedItem,
                            isTodoItemFocused: $isTodoItemFocused,
                            onSubmit: {
                                commitEdit(id)
                                isTodoItemFocused = false
                            },
                            onExit: {
                                // Esc discards the edit.
                                editedItemID = nil
                                isTodoItemFocused = false
                            },
                            onFocusChange: { isFocused in
                                if !isFocused {
                                    commitEdit(id)
                                }
                            }
                        )
                    } else {
                        TodoItemView(
                            text: todo.text,
                            isDone: todo.isDone,
                            onTap: {
                                if let current = editedItemID { commitEdit(current) }
                                editedItemID = id
                                editedItem = todo.text
                                isTodoItemFocused = true
                            }
                        )
                        .transition(.opacity)
                    }

                    Spacer()

                    DeleteButton(onClick: {
                        todos.removeAll { $0.id == id }
                    })
                }
                .listRowSeparator(.hidden)
                .accessibilityAction(named: Text("Move up")) { moveTask(id, by: -1) }
                .accessibilityAction(named: Text("Move down")) { moveTask(id, by: 1) }
            }
            .onMove(perform: move)
        }
        .overlay {
            if todos.isEmpty {
                Text("No tasks")
                    .foregroundColor(.secondary)
            }
        }
    }

    private func moveTask(_ id: Todo.ID, by offset: Int) {
        guard let index = todos.firstIndex(where: { $0.id == id }) else { return }
        let target = index + offset
        guard todos.indices.contains(target) else { return }
        // `toOffset` is the insertion point before removal, so moving down needs +1.
        todos.move(fromOffsets: IndexSet(integer: index), toOffset: offset > 0 ? target + 1 : target)
    }

    /// Saves the edit only if this row is still the one being edited
    /// (submit and focus loss can both fire for the same edit).
    private func commitEdit(_ id: Todo.ID) {
        guard editedItemID == id else { return }
        editedItemID = nil
        todos.commitEdit(id: id, text: editedItem)
    }

    private func move(from source: IndexSet, to destination: Int) {
        withAnimation(.easeInOut(duration: 0.05)) {
            todos.move(fromOffsets: source, toOffset: destination)
        }
    }
}

//#Preview {
//    TodoList()
//}
