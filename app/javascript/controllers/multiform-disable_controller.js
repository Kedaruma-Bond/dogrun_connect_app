import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form', 'disable_indicator']

  connect() {
    this.element.dataset['action'] = 'disable-trigger:submit->multiform-disable#disableIndicated'
  }

  disableIndicated() {
    this.formTargets.forEach((form) => {
      form.classList.add("hidden")
    })
    this.disable_indicatorTarget.classList.remove("hidden")
  }
}
