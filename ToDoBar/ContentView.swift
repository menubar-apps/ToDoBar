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
    @State private var editedItem: String = ""
    
    @State private var newTodo: String = ""
    
    @State private var editedItemIdx: Int = -1
    @State private var hoverItemIdx: Int = -1
    @State private var hoverIdx: Int = -1
    
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var IsTodoItemFocused: Bool
    
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
                            .focused($IsTodoItemFocused)
                        // press enter
                            .onSubmit {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                IsTodoItemFocused = false
                            }
                        // press esc
                            .onExitCommand(perform: {
                                editedItemIdx = -1
                                todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                IsTodoItemFocused = false
                            })
                        // click outside of textfield
                            .onChange(of: IsTodoItemFocused) { isFocused in
                                if !IsTodoItemFocused {
                                    editedItemIdx = -1
                                    todos[index] = Todo(text: editedItem, isDone: todos[index].isDone)
                                }
                            }
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(nsColor: NSColor.controlColor), lineWidth: 1)
                            )
                    } else {
                        Text(todos[index].text)
                            .foregroundColor(todos[index].isDone ? .secondary : .primary)
                            .strikethrough(todos[index].isDone)
                            .onTapGesture {
                                editedItemIdx = index
                                editedItem = todos[index].text
                                IsTodoItemFocused = true
                            }
                            .onHover { isHovered in
                                if isHovered {
                                    self.hoverIdx = index
                                } else {
                                    self.hoverIdx = -1
                                }
                                DispatchQueue.main.async {
                                    if (self.hoverIdx == index) {
                                        NSCursor.iBeam.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                            }
                    }
                    
                    Spacer()
                    
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
                .listRowSeparator(.hidden)
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
                    LaunchAtLogin.Toggle()
                    Divider()
                    Button(action: { appDelegate.openAboutWindow(nil) } ) {
                        Label("About ToDoBar", systemImage: "books.vertical")
                    }
                    Button(action: { appDelegate.quit()}) {
                        Label("Quit", systemImage: "books.vertical")
                    }
                } label: {
                    Image(systemName: "chevron.down")
                }
                .labelsHidden()
                .scaledToFit()
                .menuStyle(BorderlessButtonMenuStyle())
                .menuIndicator(.hidden)
                .frame(width: 16, height: 16)
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .padding(.trailing, 6)
                .background(Color.accentColor)
                .cornerRadius(8)
                .contentShape(Rectangle())
                
            }
        }.padding(8)
    }
}
