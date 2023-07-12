
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['checkboxes', 'submitButton', 'buttonText', 'disableText']

  connect() {
    this.updateSubmitButtonState()
    console.log(this.checkboxes)
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
      this.submitButtonTarget.classList.add("disabled:px-[10px]")
    } else {
      this.buttonTextTarget.classList.remove("hidden")
      this.disableTextTarget.classList.add("hidden")
      this.submitButtonTarget.classList.remove("disabled:px-[10px]")
    }
  }

  checkBoxesValueChanged() {
    this.updateSubmitButtonState()
  }
}
