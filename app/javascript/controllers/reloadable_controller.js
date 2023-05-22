import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reloadPart"]

  connect() {
    document.addEventListener("visibilitychange", () => {
      if (!document.hidden) {
        // location.reload();
        this.reloadPartTargets.forEach((reloadPart) => {
          reloadPart.src = reloadPart.src
        })
      }
    })
  }
}
