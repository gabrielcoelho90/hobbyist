import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { privateChatroomId: Number }
  static targets = ["messages", "form", "input", "sendButton", "messageInput"]

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
    const currentUserId = document.querySelector('meta[name="current-user-id"]').content;
    const messageElement = document.createElement("div");

    messageElement.setAttribute("id", `message-${data.id}`);
    messageElement.setAttribute("class", `message ${data.user_id == currentUserId ? 'user' : 'other'}`);
    messageElement.innerHTML = `
      <div class="bubble">
        <small>
          <strong>${data.username}</strong>
          <i>${data.created_at}</i>
        </small>
        <p>${data.content}</p>
      </div>
    `;
    this.messagesTarget.appendChild(messageElement);
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight);
  }

  send(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.sendButtonTarget.click()
    }
  }
}
