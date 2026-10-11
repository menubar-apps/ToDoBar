//
//  Extensions.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Foundation
import Defaults
import KeyboardShortcuts

extension Defaults.Keys {
    static let todos = Key<Array<Todo>>("todos", default: [])
    static let showTaskCount = Key<Bool>("showTaskCount", default: false)
    static let completedCount = Key<Int>("completedCount", default: 0)
}

extension KeyboardShortcuts.Name {
    static let toggleTodoList = Self("toggleTodoList", initial: .init(.x, modifiers: [.control, .shift]))
}

extension URL {
    /// For hard-coded, known-valid URLs only.
    init(_ literal: StaticString) {
        self.init(string: "\(literal)")!
    }
}
