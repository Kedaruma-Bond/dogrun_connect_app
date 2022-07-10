import { Controller } from "@hotwired/stimulus"
import { useClickOutside,useIntersection } from "stimulus-use"

export default class extends Controller {
  static targets = ["toggleable"]
  static values = {
    mobile: Boolean,
    visible: Boolean
  }
  options = {
    element: this.element.querySelector("#dropdown_menu")
  }
  initialize() {
    if (navigator.userAgent.match(/iPhone|Android.+Mobile/)) {
      this.mobileValue = true
    } else {
      this.mobileValue = false
    }
  }

  connect() {
    if (this.mobileValue === true ) {
      useClickOutside(this)
      useIntersection(this, this.options)
    }
  }

  toggle(event) {
    event.preventDefault()
    this.toggleableTargets.forEach((target) => {
      target.classList.toggle(target.dataset.cssClass)
    })
  }

  appear(entry) {
    this.visibleValue = true
  }

  disappear(entry) {
    this.visibleValue = false
  }

  clickOutside(event) {
    event.preventDefault()
    if (this.visibleValue === true) {
      this.toggleableTargets.forEach((target) => {
      target.classList.add(target.dataset.cssClass)
      })
    }
  }
}
