//
//  ContentView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import SwiftUI

import SwiftUI
import Defaults

struct ContentView: View {
    
    @Default(.todos) var todos
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var asd: String = ""

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
                    
                    todos[index].isDone
                    ? Text(todos[index].text).foregroundColor(.secondary).strikethrough()
                    : Text(todos[index].text)
                    
                    Spacer()
                    Button(action: {
                        todos.remove(at: index)
                    }) {
                        Image(systemName: "trash.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.top, 1)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.listStyle(.sidebar)
                        
            HStack {
                
                TextField("Type a task and hit enter", text: $asd)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .padding(.leading, 22)
                    .background(Color("textFieldBackgroundTransparent"))
                    .cornerRadius(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(
                        Image(systemName: "plus.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    ).onSubmit {
                        self.todos.append(Todo(text: asd))
                        asd = ""
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
                    Button(action: { appDelegate.quit()}) {
                        Label("Quit", systemImage: "books.vertical")
                    }
                } label: {
                }
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

struct CustomText: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
    
    init(_ text: String) {
        self.text = text
    }
}
