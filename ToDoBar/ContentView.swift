//
//  ContentView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import SwiftUI

import SwiftUI
import Defaults
import LaunchAtLogin

struct ContentView: View {
    
    @Default(.todos) var todos

    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var text: String = ""
    @FocusState private var isTextFieldFocused: Bool

    @State private var newTodo: String = ""
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var body: some View {
        VStack {
            List($todos.indices, id: \.self) { index in
                
                HStack {
                    Button(action: {
                        todos[index].isDone = !todos[index].isDone
                    }) {
                        Image(systemName: todos[index].isDone ? "checkmark.circle" : "circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.top, 1)
                    }.buttonStyle(PlainButtonStyle())
                    
                    Text(todos[index].text)
                        .foregroundColor(todos[index].isDone ? .secondary : .primary)
                        .strikethrough(todos[index].isDone)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    Button(action: {
                        todos.remove(at: index)
                    }) {
                        Image(systemName: "trash.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.top, 1)
                            .foregroundColor(.secondary)
                    }.buttonStyle(PlainButtonStyle())
                }
            }

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
                    ).onSubmit {
                        self.todos.append(Todo(text: newTodo))
                        newTodo = ""
                    }
                    .onAppear {
                                isTextFieldFocused = true
                            }

                Spacer()
                Menu {
                    Button(action: {
                        todos = todos.filter{!$0.isDone}
                    }) {
                        Label("Clear Done", systemImage: "eyeglasses")
                    }
                    Button(action: {
                        todos.removeAll()
                    }) {
                        Label("Clear All", systemImage: "book")
                    }
                    Divider()
                    Toggle("Launch at login", isOn: $launchAtLogin.isEnabled)
                    Divider()
                    Button(action: { appDelegate.openAboutWindow(nil) } ) {
                        Label("About ToDoBar", systemImage: "books.vertical")
                    }
                    Button(action: { appDelegate.quit()}) {
                        Label("Quit", systemImage: "books.vertical")
                    }
                } label: {}
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 14, height: 16)
                .padding(8)
                .padding(.trailing, 2)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
        }.padding(8)
    }
}
