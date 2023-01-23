import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect () {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', function() {
        navigator.serviceWorker.register("/service_worker", {scope: "/" }).then(function (registration) {
          console.log("ServiceWorker registration successful with scope: ", registration.scope);
        }, function (err) {
          console.log("ServiceWorker registration failed: ", err);
        });
      });
    }
  }
}
