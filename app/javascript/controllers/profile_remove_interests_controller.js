import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-remove-interests"
export default class extends Controller {
  static targets = ['resetProfileEdit', 'interestDeleteIcon','interestsDiv']

  connect() {
  }

  toggleIcons(event) {
    this.#toggleDisplayNone(event.currentTarget)
    this.#toggleDisplayNone(this.resetProfileEditTarget)
    this.interestDeleteIconTargets.forEach((element) => {
      this.#toggleDisplayNone(element)
    })
  }

  deleteInterest(event) {
    const elementId = event.currentTarget.id
    const interestId = elementId.split('_').pop()

    const token =  document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const url = `interests/${interestId}`
    const options = {
      method: 'DELETE',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': token
       }
    }

    fetch(url, options)
      .then(() => {
        this.refreshList()
      })
  }

  refreshList() {
    const url = '/profile'
    const options = {
      headers: { "Accept": "application/json" }
    }

    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        this.interestsDivTarget.innerHTML = data.interest_pills_html
      })
  }

  #toggleDisplayNone(element) {
    element.classList.toggle('d-none')
  }
}
