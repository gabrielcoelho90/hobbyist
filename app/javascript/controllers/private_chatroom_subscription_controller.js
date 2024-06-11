import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { privateChatroomId: Number }
  static targets = ["messages"]

  connect() {
    this.subscription = createConsumer().subscriptions.create(
      { channel: "PrivateChatroomChannel", id: this.privateChatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }



    )
    console.log(`Subscribed to the chatroom with the id ${this.privateChatroomIdValue}.`)
    }

    resetForm(event) {
      event.target.reset()
    }

    disconnect() {
      console.log("Unsubscribed from the chatroom")
      this.subscription.unsubscribe()
    }


    #insertMessageAndScrollDown(data) {
      this.messagesTarget.insertAdjacentHTML("beforeend", data)
      this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    }
}
