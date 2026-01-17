import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 }
  }

  connect() {
    // Trigger enter animation
    requestAnimationFrame(() => {
      this.element.classList.add("toast-enter")
    })

    // Auto-dismiss after duration
    this.dismissTimeout = setTimeout(() => {
      this.dismiss()
    }, this.durationValue)
  }

  disconnect() {
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
    }
  }

  dismiss() {
    // Clear the auto-dismiss timeout
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
    }

    // Trigger exit animation
    this.element.classList.remove("toast-enter")
    this.element.classList.add("toast-exit")

    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
