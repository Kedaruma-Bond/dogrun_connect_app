import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "image" ]
  static values = { rotation: { type: Number, default: 0 }, angle: { type: Number, default: -90 } }

  ccw_90deg (event) {
    event.preventDefault()
    this.rotationValue = (this.rotationValue + this.angleValue) % 360
    this.imageTarget.style.transform = `rotate(${this.rotationValue}deg)`
  }
}
