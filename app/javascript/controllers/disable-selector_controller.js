import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selector', 'submitButton', 'buttonText', 'icon']

  connect() {
    this.updateSubmitButtonState()
  }


  updateSubmitButtonState() {
    const isSelectorEmpty = this.selectorTarget.value === ""
    this.submitButtonTarget.disabled = isSelectorEmpty
    if(isSelectorEmpty) {
      this.buttonTextTarget.classList.add("hidden")
      this.iconTarget.classList.remove("hidden")
    } else {
      this.buttonTextTarget.classList.remove("hidden")
      this.iconTarget.classList.add("hidden")
    }

  }

  selectorValueChanged() {
    this.updateSubmitButtonState()
  }

}
