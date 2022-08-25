//
//  ToDo.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Foundation
import Defaults

struct Todo: Codable, Defaults.Serializable {
    let text: String
    var isDone: Bool = false
}
