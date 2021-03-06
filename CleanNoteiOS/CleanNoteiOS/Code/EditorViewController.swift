import UIKit
import CleanNoteCore

class EditorViewController: UIViewController {
  var interactor: EditorInteractorInput!
  @IBOutlet weak var textView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.fetchText()
    textView.becomeFirstResponder()
  }
}

extension EditorViewController: EditorInterface {
  func update(text: String) {
    textView.text = text
  }

  func present(error: RetryableError<EditorError>) {
    guard let controller = navigationController else { return }
    if EditorError.failToFetchNote == error.code {
      controller.popViewController(animated: true)
    }
    AlertHelper().show(title: "Error", text: error.localizedDescription, controller: controller)
  }

  func didSaveText(for noteID: NoteID) {
  }
}

extension EditorViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    interactor.save(text: textView.text)
  }
}
