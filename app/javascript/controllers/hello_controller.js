import { Controller } from "@hotwired/stimulus"
import _ from "lodash"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }

  handleClick() {
    this.element.textContent = _.intersection([2, 1], [2, 3]);
  }
}
