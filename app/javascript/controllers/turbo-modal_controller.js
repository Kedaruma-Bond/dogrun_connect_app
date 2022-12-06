import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal"]

  hideModal() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }

  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
