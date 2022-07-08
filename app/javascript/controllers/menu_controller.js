import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"

export default class extends Controller {
  static targets = ["toggleable"]

  connect() {
    useClickOutside(this)
  }

  toggle(event) {
    event.preventDefault()
    
    this.toggleableTargets.forEach((target) => {
      target.classList.toggle(target.dataset.cssClass)
    })
  }

  clickOutside(event) {
    event.preventDefault()
    console.log('it works')
    this.toggleableTargets.forEach((target) => {
    target.classList.add(target.dataset.cssClass)
    })
  }
}
