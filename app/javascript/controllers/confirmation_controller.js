import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ "button_1", "button_2" ]
  confirm_1(event) {
    console.log(this.button_1Target.dataset.message)
    if (!(this.element.dataset.turbo_confirm = this.button_1Target.dataset.message)) {
      event.preventDefault()
    }
  }
  confirm_2(event) {
    console.log(this.button_2Target.dataset.message)
  
  }
}
