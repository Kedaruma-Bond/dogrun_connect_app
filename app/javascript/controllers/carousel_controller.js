import { Splide } from '@splidejs/splide'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {
    this.splide = new Splide( ".splide", {
      type: 'loop',
      speed: 1000,
      gap: 20,
      autoplay: true,
      interval: 3500,
      drag: 'free',
      snap: true,
    } )
    this.splide.mount()
  }
}
