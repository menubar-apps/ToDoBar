//
//  ContentView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import SwiftUI
import Defaults
import LaunchAtLogin

struct ContentView: View {
    
    @Default(.todos) var todos
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var text: String = ""
    @State private var editedItem: String = ""
    
    @State private var newTodo: String = ""
    
    @State private var editedItemIdx: Int = -1
    @State private var hoverItemIdx: Int = -1
    @State private var hoverIdx: Int = -1
    
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isTodoItemFocused: Bool
    
    var body: some View {
        VStack {
            TodoList(
                todos: $todos,
                editedItemIdx: $editedItemIdx,
                hoverIdx: $hoverIdx,
                hoverItemIdx: $hoverItemIdx,
                isTodoItemFocused: $isTodoItemFocused,
                editedItem: $editedItem
            )
            .scrollContentBackground(.hidden)
            
            HStack {
            NewTodoField(
                newTodo: $newTodo,
                isTextFieldFocused: $isTextFieldFocused,
                onAddTodo: {
                    self.todos.append(Todo(text: newTodo))
                    newTodo = ""
                }
            )
            
            Spacer()
            
            MenuView(todos: $todos, appDelegate: appDelegate)
        }
        }
        .padding(8)
    }
}
