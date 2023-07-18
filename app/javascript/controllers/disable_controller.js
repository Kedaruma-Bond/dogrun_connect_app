import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    with: String
    }
  static targets = ['spinner', 'submitButton', 'buttonText']

  connect() {
    this.element.dataset['action'] = 'submit->disable#disableForm'
    this.backButton = this.element.querySelector('[data-action="back-button#goBack"]')
  }

  disableForm() {
    const isBackButtonPressed = this.backButton && this.backButton === document.activeElement

    if(!isBackButtonPressed) {
      this.submitButtonTargets.forEach((button) => {
        button.disabled = true
      })
      this.buttonTextTarget.textContent = this.withValue
      this.spinnerTarget.classList.remove("hidden")
    }
  }

}
