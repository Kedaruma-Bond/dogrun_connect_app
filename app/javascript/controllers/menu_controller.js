import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ 'open_button', 'close_button', 'container' ]

  connect() {
    this.toggleClass = 'hidden'
    this.enterClass = 'animate-scale-in-ver-top'
    this.exitClass = 'animate-scale-out-ver-top'
  }

  disconnect() {
    this.close()
  }

  open() {
    this.containerTarget.classList.remove(this.toggleClass, this.exitClass)
    this.containerTarget.classList.add(this.enterClass)
    this.open_buttonTarget.classList.add(this.toggleClass)
    this.close_buttonTarget.classList.remove(this.toggleClass)
  }

  close() {
    this.containerTarget.classList.add(this.exitClass)
    this.containerTarget.classList.remove(this.enterClass)
    this.open_buttonTarget.classList.remove(this.toggleClass)
    this.close_buttonTarget.classList.add(this.toggleClass)
    // this.containerTarget.classList.add(this.toggleClass)
  }

  closeBackground(e) {
    if (e && this.open_buttonTarget.contains(e.target)) {
      return
    }
    this.close()
  }
}
