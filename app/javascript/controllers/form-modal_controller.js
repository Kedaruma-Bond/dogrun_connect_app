import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form"]

  open(event) {
    event.preventDefault();

    this.modalTarget.showModal();

    this.modalTarget.addEventListener('click', (e) => this.backdropClick(e));
  }

  backdropClick(event) {
    event.target === this.modalTarget && this.close(event)
  }

  submitEnd(event) {
    if (event.detail.success) {
      this.modalTarget.close()
    }
  }

  close(event) {
    event.preventDefault();

    this.modalTarget.close();

    if (this.hasFormTarget) {
      this.formTarget.reset();
    }
  }

}
