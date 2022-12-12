import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal", "background", "imagePreview" ];

  handleOpen(event) {
    event.preventDefault();
    this.modalTarget.classList.remove("hidden");
    this.backgroundTarget.classList.remove("opacity-0");
    this.backgroundTarget.classList.add("opacity-100");
    this.showPreview(event.params)
  }

  handleClose(event) {
    event.preventDefault();
    this.modalTarget.classList.add("hidden");
    this.backgroundTarget.classList.remove("opacity-100");
    this.backgroundTarget.classList.add("opacity-0");
  }

  showPreview(params) {
    this.imagePreviewTarget.src = params.source
    console.log(params)
  }
}
