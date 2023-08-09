import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    with: String
    }
  static targets = ['spinner', 'submitButton', 'buttonText']

  connect() {
    this.element.dataset['action'] = 'submit->disable#disableForm'
  }

  disableForm() {
    this.submitButtonTargets.forEach((button) => {
      button.disabled = true
    })
    this.buttonTextTarget.textContent = this.withValue
    this.spinnerTarget.classList.remove("hidden")
  }
}
