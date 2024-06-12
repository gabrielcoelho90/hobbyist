import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="groupchat-subscription"
export default class extends Controller {
  static values = { groupchatId: Number}
  static targets = [ "messages" ]


  connect() {
    console.log(`Subscribe to the groupchat with the id ${this.groupchatIdValue}.`)
    this.subscription = createConsumer().subscriptions.create(
      { channel: "GroupchatChannel", id: this.groupchatIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
  }

  #insertMessageAndScrollDown(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    console.log("Unsubscribed from the groupchat")
    this.subscription.unsubscribe()
  }

}
