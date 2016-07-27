@testable import CleanNoteCore

class MockListInteractorInput: ListInteractorInput {
  var shouldExpectFetchNotes = false
  var didCallFetchNotes = false

  func expectFetchNotes() {
    shouldExpectFetchNotes = true
  }

  func assert() -> Bool {
    if shouldExpectFetchNotes && !didCallFetchNotes {
      return false
    }
    return true
  }

  func fetchNotes() {
    didCallFetchNotes = true
  }
}