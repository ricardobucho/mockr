import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Add enter animation
    requestAnimationFrame(() => {
      this.element.classList.add("delete-modal-enter")
    })

    // Listen for escape key
    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.cancel()
    }
  }

  cancel() {
    this.element.classList.remove("delete-modal-enter")
    this.element.classList.add("delete-modal-exit")
    
    setTimeout(() => {
      this.element.remove()
    }, 200)
  }

  // Close modal when clicking on backdrop (but not on modal itself)
  backdropClick(event) {
    if (event.target === this.element) {
      this.cancel()
    }
  }
}
