import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    with: String
    }

  connect() {
    this.element.dataset['action'] = 'submit->disable#disableForm'
    this.backButton = this.element.querySelector('[data-action="back-button#goBack"]')
    this.submitButton = this.element.querySelector("input[type='submit']")
  }


  disableForm() {
    const isBackButtonPressed = this.backButton && this.backButton === document.activeElement

      if(!isBackButtonPressed) {
        this.submitButton.disabled = true
        this.submitButton.value = this.withValue
      }
  }

}
