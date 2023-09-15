import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  open(event) {
    event.preventDefault();

    this.modalTarget.classList.add('open:animate-fade-in')
    this.modalTarget.classList.add('open:backdrop:animate-fade-in')

    this.modalTarget.showModal();

    this.modalTarget.addEventListener('click', (e) => this.backdropClick(e));
  }

  backdropClick(event) {
    event.target === this.modalTarget && this.close(event)
  }

  close(event) {
    event.preventDefault();
    
    this.modalTarget.classList.remove('open:animate-fade-in')
    this.modalTarget.classList.remove('open:backdrop:animate-fade-in')
    this.modalTarget.classList.add('animate-fade-out')
    this.modalTarget.classList.add('backdrop:animate-fade-out')
    setTimeout(() => {
      this.modalTarget.close();
    }, 300)
  }
}
