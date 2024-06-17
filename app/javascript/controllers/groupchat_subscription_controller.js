import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

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

}
