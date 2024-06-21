import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="action-buttons"
export default class extends Controller {
  static targets = ['messageButton', 'friendshipButton']
  static values = {
    receiverId: Number,
    friendshipStatus: String
  }

  connect() {
  }

  messageButtonToggle() {
    const token =  document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const url = `/private_chatrooms?receiver_id=${this.receiverIdValue}`
    const options = {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': token
       }
    }

    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        this.messageButtonTarget.innerHTML = data.message_button_html
      })
  }

  friendButtonToggle() {
    let friendshipUrl = ''
    if (this.friendshipStatusValue === 'pending') {
      friendshipUrl = `&friendship_status=pending`
    }

    const token =  document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    const url = `/friendships?receiver_id=${this.receiverIdValue}${friendshipUrl}`
    const options = {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': token
       }
    }

    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        this.friendshipButtonTarget.innerHTML = data.friendship_button_html
      })
  }
}
