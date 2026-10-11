//
//  ToDo.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2022-08-24.
//

import Foundation
import Defaults

struct Todo: Codable, Identifiable, Equatable, Defaults.Serializable {
    var id = UUID()
    var text: String
    var isDone: Bool = false

    init(id: UUID = UUID(), text: String, isDone: Bool = false) {
        self.id = id
        self.text = text
        self.isDone = isDone
    }

    // Tasks saved by versions before 1.6 have no `id`; give them one on load.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        text = try container.decode(String.self, forKey: .text)
        isDone = try container.decodeIfPresent(Bool.self, forKey: .isDone) ?? false
    }
}

extension Array where Element == Todo {
    var unfinishedCount: Int { filter { !$0.isDone }.count }

    /// Appends a task. Returns false (and changes nothing) if the text is blank.
    @discardableResult
    mutating func add(text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        append(Todo(text: trimmed))
        return true
    }

    /// Saves an edited task. Blank text deletes the task.
    mutating func commitEdit(id: Todo.ID, text: String) {
        guard let index = firstIndex(where: { $0.id == id }) else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            remove(at: index)
        } else {
            self[index].text = trimmed
        }
    }
}

enum ReviewPrompt {
    /// Completed-task counts at which we ask for a rating.
    /// (macOS itself limits how often the prompt is actually shown.)
    static let thresholds: Set<Int> = [10, 50, 150]

    static func shouldRequest(completedCount: Int) -> Bool {
        thresholds.contains(completedCount)
    }
}
