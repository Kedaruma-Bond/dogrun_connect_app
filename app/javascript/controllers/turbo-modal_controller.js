import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal"]

  hideModal() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }

  // esc でmodal close 
  // action: "keyup@window->turbo-modal#closeWithKeyboard"
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  // modal外をタップで close
  // action: "click@window->turbo-modal#closeBackground"
  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
