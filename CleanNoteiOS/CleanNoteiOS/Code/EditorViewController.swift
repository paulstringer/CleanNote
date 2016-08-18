import UIKit
import CleanNoteCore

class EditorViewController: UIViewController {
  var interactor: EditorInteractorInput!
  @IBOutlet weak var textView: UITextView!

  override func viewDidLoad() {
    interactor.fetchText()
    textView.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    interactor.save(text: textView.text)
  }
}

extension EditorViewController: EditorInterface {
  func update(text: String) {
    textView.text = text
  }

  func show(error: String) {
    guard let controller = navigationController else { return }
    AlertHelper().show(title: "Error", text: error, controller: controller)
  }

  func didSaveText(for noteID: NoteID) {
  }
}
