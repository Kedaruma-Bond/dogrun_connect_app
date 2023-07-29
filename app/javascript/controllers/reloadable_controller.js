import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reloadFrame"]

  connect() {
    document.addEventListener("visibilitychange", async() => {
      if (!document.hidden) {
        this.reloadFrameTargets.forEach((reloadFrame) => {
          reloadFrame.src = reloadFrame.src
        })
      }
    })
  }
}
