import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
    this.enterClass = 'animate-fade-in'
    this.exitClass = 'animate-fade-out'
  }

  hideModal() {
    this.unmount_animate()
    setTimeout(() => {
      this.element.parentElement.removeAttribute("src")
      this.element.remove()
    }, 150)
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.hideModal()
    }
  }

  unmount_animate() {
    this.modalTarget.classList.remove(this.enterClass)
    this.modalTarget.classList.add(this.exitClass)
  }
}
