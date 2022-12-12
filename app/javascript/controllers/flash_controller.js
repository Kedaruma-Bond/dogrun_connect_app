import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 10000);
  }

  disconnect() {
    this.dismiss()
  }

  dismiss() {
    this.element.remove();
  }

  close(event) {
    event.preventDefault()
    this.dismiss()
  }
}
