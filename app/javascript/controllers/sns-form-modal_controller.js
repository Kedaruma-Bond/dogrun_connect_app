import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  open() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }

  hideModal() {
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  }

  // modal外をタップで close
  // action: "click@window->turbo-modal#closeBackground"
  closeBackground(e) {
    if (e && this.containerTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
