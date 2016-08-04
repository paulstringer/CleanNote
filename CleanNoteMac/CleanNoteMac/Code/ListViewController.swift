import Cocoa
import CleanNoteCore

protocol ListViewControllerDelegate: class {
  func didSelect(noteID: NoteID)
  func didDeselectAllNotes()
}

class ListViewController: NSViewController, ListInterface, NSTableViewDataSource, NSTableViewDelegate {

  @IBOutlet weak var tableView: NSTableView!
  weak var delegate: ListViewControllerDelegate?

  var listNotes = [ListViewNote]()

  func update(notes: [ListViewNote]) {
    listNotes = notes
    tableView.reloadData()
  }

  func update(note: ListViewNote) {
    guard let index = indexForListNote(with: note.id) else { return }
    listNotes[index] = note
    reload(row: index)
  }

  private func indexForListNote(with noteID: NoteID) -> Int? {
    return listNotes.index { $0.id == noteID }
  }

  private func reload(row: Int) {
    let rowIndexes = IndexSet(integer: row)
    let columnIndexes = IndexSet(integer: 0)
    tableView.reloadData(forRowIndexes: rowIndexes, columnIndexes: columnIndexes)
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return listNotes.count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

    let cellView = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView

    if let label = cellView.textField {
      let listViewNote = listNotes[row]
      label.stringValue = listViewNote.summary
    }

    return cellView
  }

  func tableViewSelectionDidChange(_ notification: Notification) {
    if let noteID = noteIDForSelectedRow() {
      delegate?.didSelect(noteID: noteID)
    } else {
      delegate?.didDeselectAllNotes()
    }
  }

  private func noteIDForSelectedRow() -> NoteID? {
    let row = tableView.selectedRow
    return -1 == row ? nil : listNotes[row].id
  }

  func select(noteID: NoteID) {
    guard let row = indexForListNote(with: noteID) else { return }
    let rowIndexes = IndexSet(integer: row)
    
    tableView.selectRowIndexes(rowIndexes, byExtendingSelection: false)
    tableView.scrollRowToVisible(row)
  }
}