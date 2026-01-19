import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "stackedPanel"]

  connect() {
    // Listen for turbo frame loads to open drawer
    this.element.addEventListener("turbo:frame-load", this.handleFrameLoad.bind(this))
    
    // Listen for turbo stream updates that might clear frames
    document.addEventListener("turbo:before-stream-render", this.handleStreamRender.bind(this))
    
    // Listen for escape key
    document.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
    document.removeEventListener("turbo:before-stream-render", this.handleStreamRender.bind(this))
  }

  handleFrameLoad(event) {
    const frameId = event.target.id
    
    if (frameId === "drawer" && event.target.innerHTML.trim() !== "") {
      this.open()
    } else if (frameId === "drawer-stacked" && event.target.innerHTML.trim() !== "") {
      this.openStacked()
    }
  }

  handleStreamRender(event) {
    const stream = event.target
    const action = stream.getAttribute("action")
    const target = stream.getAttribute("target")
    
    // Check if we're clearing/updating a drawer frame with empty content
    if (action === "update" && target === "drawer-stacked") {
      const template = stream.querySelector("template")
      const content = template ? template.innerHTML.trim() : ""
      if (content === "") {
        this.closeStacked()
        event.preventDefault() // Don't render empty content, we'll handle it
      }
    } else if (action === "update" && target === "drawer") {
      const template = stream.querySelector("template")
      const content = template ? template.innerHTML.trim() : ""
      if (content === "") {
        this.close()
        event.preventDefault()
      }
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      if (this.hasStackedPanelTarget && this.stackedPanelTarget.classList.contains("open")) {
        this.closeStacked()
      } else if (this.hasPanelTarget && this.panelTarget.classList.contains("open")) {
        this.close()
      }
    }
  }

  open() {
    document.body.classList.add("drawer-open")
    this.backdropTarget.classList.add("open")
    this.panelTarget.classList.add("open")
  }

  close() {
    this.panelTarget.classList.remove("open")
    this.backdropTarget.classList.remove("open")
    document.body.classList.remove("drawer-open")
    
    // Clear the frame content after animation
    setTimeout(() => {
      const frame = document.getElementById("drawer")
      if (frame) frame.innerHTML = ""
    }, 300)
  }

  openStacked() {
    this.stackedPanelTarget.classList.add("open")
  }

  closeStacked() {
    this.stackedPanelTarget.classList.remove("open")
    
    // Clear the stacked frame content after animation
    setTimeout(() => {
      const frame = document.getElementById("drawer-stacked")
      if (frame) frame.innerHTML = ""
    }, 300)
  }

  closeAll() {
    this.closeStacked()
    setTimeout(() => this.close(), 100)
  }

  // Prevent closing on backdrop click (per user requirement)
  backdropClick(event) {
    // Do nothing - user requested that clicking outside should NOT close
  }
}
