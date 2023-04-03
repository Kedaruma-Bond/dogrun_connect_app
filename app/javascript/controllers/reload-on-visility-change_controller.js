import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener("visibilitychange", () => {
      if (!document.hidden) {
        location.reload();
      }
    });
  }
}
