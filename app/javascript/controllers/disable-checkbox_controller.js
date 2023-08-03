
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['checkboxes', 'submitButton', 'buttonText', 'disableText']

  connect() {
    this.updateSubmitButtonState()
  }

  updateSubmitButtonState() {
    const checkCount = this.checkboxesTargets.filter(checkbox => checkbox.checked).length
    const isCheckBoxEmpty = checkCount === 0
    this.submitButtonTargets.forEach((button) => {
      button.disabled = isCheckBoxEmpty
    })
    if(isCheckBoxEmpty) {
      this.buttonTextTarget.classList.add("hidden")
      this.disableTextTarget.classList.remove("hidden")
    } else {
      this.buttonTextTarget.classList.remove("hidden")
      this.disableTextTarget.classList.add("hidden")
    }
  }

  checkBoxesValueChanged() {
    this.updateSubmitButtonState()
  }
}
