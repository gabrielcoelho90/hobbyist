import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="create-interests"
export default class extends Controller {
  static targets = ['form']

  connect() {
  }

  setInterests() {
    this.formTargets.forEach((form) => {
      const url = form.action
      const options = {
        method: "POST",
        headers: { "Accept": "application/json" },
        body: new FormData(form)
      }

      fetch(url, options)
        .then(response => response.json())
        .then((data) => {
          console.log(data)
        })
    })
  }
}
