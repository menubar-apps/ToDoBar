//
//  Extensions.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let todos = Key<Array<Todo>>("todos", default: [])
}
