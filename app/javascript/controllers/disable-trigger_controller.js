import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.dataset['action'] = 'turbo:submit-start->disable-trigger#handleFormSubmit'
  }

  handleFormSubmit(event) {
    if (event.detail.cancelled) {
      // キャンセルされた場合は処理を中断する
      return
    }

    this.dispatch('submit')
  }

}
