import { Controller } from "@hotwired/stimulus"
import { useIntersection } from 'stimulus-use'

export default class extends Controller {
  static targets = ["searchForm", "button"]
  options = {
    element: this.searchFormTarget,
    threshold: 1
  }

  connect() {
    this.enterClass = 'animate-fade-in'
    this.exitClass = 'animate-fade-out'
    useIntersection(this, this.options)
  }

  appear() {
    this.buttonTarget.classList.remove(this.enterClass)
    this.buttonTarget.classList.add(this.exitClass)
    setTimeout(() => {
      this.buttonTarget.classList.add("hidden")
    }, 300)
  }
  disappear() {
    this.buttonTarget.classList.remove(this.exitClass)
    this.buttonTarget.classList.add(this.enterClass)
    this.buttonTarget.classList.remove("hidden")
  }
}
