import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    with: String
    }
  static targets = ['spinner', 'submitButton', 'buttonText']

  connect() {
    this.element.dataset['action'] = 'turbo:submit-start->disable-confirm#handleFormSubmit'
  }

  handleFormSubmit(event) {
    if (event.detail.cancelled) {
      // キャンセルされた場合は処理を中断する
      return
    }

    this.dispatch('submit')

    this.disabledSubmitButton()
  }
  
  disabledSubmitButton() {
    this.submitButtonTargets.forEach((button) => {
      button.disabled = true
    })
    this.buttonTextTarget.textContent = this.withValue
    this.spinnerTarget.classList.remove("hidden")
  }
}
