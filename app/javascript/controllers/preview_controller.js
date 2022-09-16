import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [  
    "imageUploader", 
    "imagePreview" ]

  connect() {
    this.updatePreview()
  }
  updatePreview() {
    if (this.imageUploaderTarget.files.length) {
    this.showPreview()
    }
  }
  showPreview() {
    this.imagePreviewTarget.src = URL.createObjectURL(this.imageUploaderTarget.files[0])
  }
}
