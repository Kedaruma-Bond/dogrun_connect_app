import { Controller } from "stimulus"

export default class extends Controller {
  // static targets = [ "source", "disable" ]
  static get targets() {
    return ["source", "disable"]
  }

  connect() {
    this.updateDisabledElements()
  }

  updateDisabledElements() {
    this.disableTargets.forEach(element => {
      element.disabled = !this.sourceTarget.checked
    })
  }
}
