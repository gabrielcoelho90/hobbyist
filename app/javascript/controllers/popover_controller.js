import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popover"
export default class extends Controller {
  connect() {
    console.log("hello")
    const popover = new bootstrap.Popover(this.element)
  }
}
