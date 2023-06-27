import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    with: String
    }

  connect() {
    this.element.dataset['action'] = 'submit->disable#disableForm'
    this.backButton = this.element.querySelector('[data-action="back-button#goBack"]')
  }

  disableForm() {
    const submitButtons = this.submitButtons()
    const isBackButtonPressed = submitButtons.some(button => button === document.activeElement)

    console.log(isBackButtonPressed)

    submitButtons.forEach((button) => {
      if (isBackButtonPressed && button !== this.backButton) {
        button.disabled = true
        button.value = this.withValue
      }
    })
  }

  submitButtons() {
    return Array.from(this.element.querySelectorAll("input[type='submit']"))
  }
}
