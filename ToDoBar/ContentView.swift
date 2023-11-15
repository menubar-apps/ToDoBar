//
//  ContentView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import SwiftUI

import SwiftUI
import Defaults
//import LaunchAtLogin

struct ContentView: View {
    
    @Default(.todos) var todos
    
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var text: String = ""
    @State private var editedItem: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var newTodo: String = ""
    //    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable
    
    @State private var editedItemIdx: Int = -1
    @State private var hoverItemIdx: Int = -1
    @State private var hoverIdx: Int = -1
    
    @FocusState private var focusedField: Bool
    
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
                    
                    if editedItemIdx == index {
                        TextField("", text: $editedItem, axis: .vertical)
                            .focused($focusedField)
                            .onSubmit {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                focusedField = false
                            }
                            .onExitCommand(perform: {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                focusedField = false
                            })
                    } else {
                        Text(todos[index].text)
                            .foregroundColor(todos[index].isDone ? .secondary : .primary)
                            .strikethrough(todos[index].isDone)
                        //                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                editedItemIdx = index
                                editedItem = todos[index].text
                                focusedField = true
                            }
                            .onHover { isHovered in
                                if isHovered {
                                    self.hoverIdx = index
                                } else {
                                    self.hoverIdx = -1
                                }
                                DispatchQueue.main.async {
                                    if (self.hoverIdx == index) {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            }
                    }
                    
                    Spacer()
                    
                    //                    if hoverItemIdx == index {
                    Button(action: {
                        todos.remove(at: index)
                    }) {
                        Image(systemName: "trash.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.top, 1)
                            .foregroundColor(hoverItemIdx == index ? .primary : .secondary)
                            .opacity(hoverItemIdx == index ? 1 : 0.2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { isHovered in
                        if isHovered {
                            withAnimation {
                                self.hoverItemIdx = index
                            }
                        } else {
                            self.hoverItemIdx = -1
                        }
                    }
                    .listRowSeparator(.hidden)
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
                    //                    Toggle("Launch at login", isOn: $launchAtLogin.isEnabled)
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
