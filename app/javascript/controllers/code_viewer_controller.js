import { Controller } from "@hotwired/stimulus"
import CodeMirror from "codemirror"
import "codemirror/mode/javascript/javascript"
import "codemirror/mode/htmlmixed/htmlmixed"
import "codemirror/mode/xml/xml"

export default class extends Controller {
  static targets = ["source"]
  static values = {
    mode: { type: String, default: "application/json" },
    height: { type: String, default: "auto" }
  }

  connect() {
    // Delay initialization slightly to ensure modal is visible
    // This fixes CodeMirror rendering issues when inside hidden containers
    setTimeout(() => {
      this.initializeViewer()
      this.observeThemeChanges()
    }, 50)
  }

  disconnect() {
    if (this.themeObserver) {
      this.themeObserver.disconnect()
    }
  }

  initializeViewer() {
    const isDarkMode = document.documentElement.getAttribute("data-bs-theme") === "dark"
    const code = this.sourceTarget.value || ""
    
    this.editor = CodeMirror(this.element, {
      value: code,
      mode: this.modeValue,
      theme: isDarkMode ? "material-darker" : "default",
      lineNumbers: true,
      lineWrapping: true,
      readOnly: true,
      cursorBlinkRate: -1 // Hide cursor in read-only mode
    })

    // Set height
    if (this.heightValue === "auto") {
      // Auto-size based on content, with max height
      // CodeMirror has ~4px padding top/bottom, and line-height is ~1.5 * 13px font = ~20px
      const lineCount = this.editor.lineCount()
      const lineHeight = 21
      const padding = 10 // account for CodeMirror internal padding
      const maxHeight = 400
      const calculatedHeight = Math.min((lineCount * lineHeight) + padding, maxHeight)
      this.editor.setSize(null, calculatedHeight + "px")
    } else {
      this.editor.setSize(null, this.heightValue)
    }

    // Refresh to fix any rendering issues
    this.editor.refresh()
  }

  observeThemeChanges() {
    this.themeObserver = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === "data-bs-theme") {
          const isDarkMode = document.documentElement.getAttribute("data-bs-theme") === "dark"
          this.editor.setOption("theme", isDarkMode ? "material-darker" : "default")
        }
      })
    })

    this.themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["data-bs-theme"]
    })
  }
}
