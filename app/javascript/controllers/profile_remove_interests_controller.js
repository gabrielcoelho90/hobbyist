import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-remove-interests"
export default class extends Controller {
  static targets = ['resetProfileEdit', 'interestDelete']

  connect() {
  }

  toggleIcons(event) {
    // console.log(event.currentTarget);
    // console.log(this.resetProfileEditTarget);
    // this.interestDeleteTargets.forEach((element) => {
    //   console.log(element);
    // })
    this.#toggleDisplayNone(event.currentTarget)
    this.#toggleDisplayNone(this.resetProfileEditTarget)
    this.interestDeleteTargets.forEach((element) => {
      this.#toggleDisplayNone(element)
    })
  }

  #toggleDisplayNone(element) {
    element.classList.toggle('d-none')
  }
}
