import XCTest
import SwiftUI
import Defaults
@testable import ToDoBar

final class TodoTests: XCTestCase {

    // MARK: Saved data compatibility

    func testDecodesTasksSavedByVersion15() throws {
        // v1.5 stored only `text` and `isDone`.
        let json = #"[{"text":"Buy milk","isDone":true},{"text":"Call mom","isDone":false}]"#
        let todos = try JSONDecoder().decode([Todo].self, from: Data(json.utf8))
        XCTAssertEqual(todos.map(\.text), ["Buy milk", "Call mom"])
        XCTAssertEqual(todos.map(\.isDone), [true, false])
        XCTAssertNotEqual(todos[0].id, todos[1].id)
    }

    func testDefaultsLoadsTasksStoredInTheV15Format() throws {
        // Defaults 6.x stored each Codable task as a JSON string inside an array.
        let suite = "ToDoBarTests.legacy"
        let userDefaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        userDefaults.removePersistentDomain(forName: suite)
        defer { userDefaults.removePersistentDomain(forName: suite) }
        userDefaults.set([#"{"text":"Buy milk","isDone":true}"#, #"{"text":"Call mom","isDone":false}"#], forKey: "todos")

        let key = Defaults.Key<[Todo]>("todos", default: [], suite: userDefaults)
        XCTAssertEqual(Defaults[key].map(\.text), ["Buy milk", "Call mom"])
        XCTAssertEqual(Defaults[key].map(\.isDone), [true, false])

        // Saving again must still be readable.
        Defaults[key].add(text: "New")
        XCTAssertEqual(Defaults[key].map(\.text), ["Buy milk", "Call mom", "New"])
    }

    func testEncodeDecodeRoundTripKeepsId() throws {
        let original = Todo(text: "Write tests", isDone: true)
        let data = try JSONEncoder().encode([original])
        let decoded = try JSONDecoder().decode([Todo].self, from: data)
        XCTAssertEqual(decoded, [original])
    }

    // MARK: Adding

    func testAddTrimsText() {
        var todos: [Todo] = []
        XCTAssertTrue(todos.add(text: "  hello \n"))
        XCTAssertEqual(todos.map(\.text), ["hello"])
    }

    func testAddRejectsBlankText() {
        var todos: [Todo] = []
        XCTAssertFalse(todos.add(text: ""))
        XCTAssertFalse(todos.add(text: "   \n "))
        XCTAssertTrue(todos.isEmpty)
    }

    // MARK: Editing

    func testCommitEditUpdatesTextAndKeepsDoneState() {
        var todos = [Todo(text: "a", isDone: true), Todo(text: "b")]
        todos.commitEdit(id: todos[0].id, text: " A2 ")
        XCTAssertEqual(todos[0].text, "A2")
        XCTAssertTrue(todos[0].isDone)
    }

    func testCommitEditWithBlankTextDeletesTask() {
        var todos = [Todo(text: "a"), Todo(text: "b")]
        todos.commitEdit(id: todos[0].id, text: "   ")
        XCTAssertEqual(todos.map(\.text), ["b"])
    }

    func testCommitEditAfterReorderHitsTheRightTask() {
        var todos = [Todo(text: "a"), Todo(text: "b"), Todo(text: "c")]
        let editedID = todos[2].id
        todos.move(fromOffsets: IndexSet(integer: 2), toOffset: 0) // c, a, b
        todos.removeAll { $0.text == "a" }                        // c, b
        todos.commitEdit(id: editedID, text: "c2")
        XCTAssertEqual(todos.map(\.text), ["c2", "b"])
    }

    func testCommitEditForMissingTaskDoesNothing() {
        var todos = [Todo(text: "a")]
        todos.commitEdit(id: UUID(), text: "zzz")
        XCTAssertEqual(todos.map(\.text), ["a"])
    }

    // MARK: Count and rating prompt

    func testUnfinishedCount() {
        let todos = [Todo(text: "a", isDone: true), Todo(text: "b"), Todo(text: "c")]
        XCTAssertEqual(todos.unfinishedCount, 2)
        XCTAssertEqual([Todo]().unfinishedCount, 0)
    }

    func testReviewPromptThresholds() {
        XCTAssertFalse(ReviewPrompt.shouldRequest(completedCount: 9))
        XCTAssertTrue(ReviewPrompt.shouldRequest(completedCount: 10))
        XCTAssertFalse(ReviewPrompt.shouldRequest(completedCount: 11))
        XCTAssertTrue(ReviewPrompt.shouldRequest(completedCount: 50))
    }
}
