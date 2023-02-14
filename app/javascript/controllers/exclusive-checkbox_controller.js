import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "checkboxes" ]

  exclusiveAction(event) {
    event.preventDefault()
    if (event && this.checkboxesTarget.checked) {
        this.checkboxesTargets.checked = false
        this.checkboxesTarget.checked = true
    }

  }
  // $(function(){
  //   $('.check').on('click', function() {
  //     if ($(this).prop('checked')){
  //       // 一旦全てをクリアして再チェックする
  //       $('.check').prop('checked', false);
  //       $(this).prop('checked', true);
  //     }
  //   });
  // });
}
