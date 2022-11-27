import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "background", "frame"];

  handleOpen(event) {
    event.preventDefault();
    this.modalTarget.classList.remove("hidden");
    this.backgroundTarget.classList.remove("opacity-0");
    this.backgroundTarget.classList.add("opacity-100");

    const { url } = event.params
    this.frameTarget.src = url
  }

  handleClose(event) {
    event.preventDefault();
    this.modalTarget.classList.add("hidden");
    this.backgroundTarget.classList.remove("opacity-100");
    this.backgroundTarget.classList.add("opacity-0");
  }
}
