import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {
    this.enterClass = 'animate-tilt-in-right-2'
    this.exitClass = 'animate-fade-out'

    setTimeout(() => {
      this.dismiss();
    }, 10000);
  }

  unmount_animate() {
    this.element.classList.remove(this.enterClass)
    this.element.classList.add(this.exitClass)
  }

  disconnect() {
    this.dismiss()
  }

  dismiss() {
    this.unmount_animate()
    setTimeout(() => {
      this.element.remove();
    }, 300)
  }

  close(event) {
    event.preventDefault()
    this.dismiss()
  }
}
