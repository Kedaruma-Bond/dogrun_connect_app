import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    if (window.FB) {
      window.FB.XFBML.parse();
    }
  }
}
