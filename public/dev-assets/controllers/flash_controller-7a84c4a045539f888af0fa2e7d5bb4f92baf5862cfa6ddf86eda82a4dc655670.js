import { Controller } from "@hotwired/stimulus"
import _ from "lodash"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 3000);
  }
  dismiss() {
    this.element.remove();
  }
};
