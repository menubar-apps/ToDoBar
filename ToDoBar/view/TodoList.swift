//
//  TodoList.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct TodoList: View {
    @Binding var todos: [Todo]
    @Binding var editedItemIdx: Int
    @Binding var hoverIdx: Int
    @Binding var hoverItemIdx: Int
    
    @FocusState.Binding var isTodoItemFocused: Bool
    @Binding var editedItem: String
    
    var body: some View {
        List {
            ForEach($todos.indices, id: \.self) { index in
                HStack {
                    TodoItemButton(isDone: $todos[index].isDone)
                    
                    if editedItemIdx == index {
                        EditableTodoItem(
                            editedItem: $editedItem,
                            isTodoItemFocused: $isTodoItemFocused,
                            onSubmit: {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                isTodoItemFocused = false
                            },
                            onExit: {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                isTodoItemFocused = false
                            },
                            onFocusChange: { isFocused in
                                if !isFocused {
                                    editedItemIdx = -1
                                    todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                }
                            }
                        )
                    } else {
                        TodoItemView(
                            text: todos[index].text,
                            isDone: todos[index].isDone,
                            onTap: {
                                editedItemIdx = index
                                editedItem = todos[index].text
                                isTodoItemFocused = true
                            },
                            onHover: { isHovered in
                                if isHovered {
                                    self.hoverIdx = index
                                } else {
                                    self.hoverIdx = -1
                                }
                                DispatchQueue.main.async {
                                    if self.hoverIdx == index {
                                        NSCursor.iBeam.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            }
                        )
                        .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    ReorderButton()
                    
                    DeleteButton(
                        isHovered: hoverItemIdx == index,
                        onClick: { todos.remove(at: index) },
                        onHover: { isHovered in
                            if isHovered {
                                withAnimation {
                                    self.hoverItemIdx = index
                                }
                            } else {
                                self.hoverItemIdx = -1
                            }
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .listRowSeparator(.hidden)
            }
            .onMove(perform: move)
        }
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
