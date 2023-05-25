import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reloadFrame"]

  connect() {
    document.addEventListener("visibilitychange", () => {
      if (!document.hidden) {
        // location.reload();
        this.reloadFrameTargets.forEach((reloadFrame) => {
          reloadFrame.src = reloadFrame.src
        })
      }
    })
  }
}
