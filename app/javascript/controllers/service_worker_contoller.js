import { Controller } from "stimulus";

export default class extends Controller {

  connect () {
    if (navigator.serviceWorker) {
      if (navigator.serviceWorker.controller) {
        // if service worker is a already running, skip to state change
        this.stateChange();
      } else {
        // Register the service worker, and wait for it to become active
        navigator.serviceWorker
          .register("/service-worker.js", {scope: "./" })
          .then(function (reg) {
            console.log("[Companion]", "Service worker registered!");
            console.log(reg)
          });
        navigator.serviceWorker.addEventListener(
          "controllerchange",
          this.controllerChange.bind(this)
        );
      }
    }
  }

  controllerChange(event) {
    console.log(
      '[controllerchange] A "controllerchange" event has happened ' +
      "within navigator.serviceWorker: ",
      event
    );
    navigator.serviceWorker.controller.addEventListener(
      "statechange",
      this.stateChange.bind(this)
    );
  }

  stateChange() {
  }
}
