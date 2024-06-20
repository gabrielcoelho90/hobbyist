import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-buttons"
export default class extends Controller {
  static targets = ['messageButton']

  connect() {
  }

  messageButtonToggle() {
  }
}
