import { Controller } from "@hotwired/stimulus"
import CodeMirror from "codemirror"
import "codemirror/mode/javascript/javascript"
import "codemirror/mode/htmlmixed/htmlmixed"
import "codemirror/mode/xml/xml"

export default class extends Controller {
  static targets = ["textarea", "editor"]
  static values = {
    mode: { type: String, default: "application/json" },
    height: { type: String, default: "300px" }
  }

  connect() {
    this.initializeEditor()
    this.observeThemeChanges()
  }

  disconnect() {
    if (this.themeObserver) {
      this.themeObserver.disconnect()
    }
  }

  initializeEditor() {
    const isDarkMode = document.documentElement.getAttribute("data-bs-theme") === "dark"
    
    this.editor = CodeMirror(this.editorTarget, {
      value: this.textareaTarget.value || "",
      mode: this.modeValue,
      theme: isDarkMode ? "material-darker" : "default",
      lineNumbers: true,
      lineWrapping: true,
      tabSize: 2,
      indentWithTabs: false,
      autoCloseBrackets: true,
      matchBrackets: true,
      styleActiveLine: true
    })

    // Set height
    this.editor.setSize(null, this.heightValue)

    // Sync changes back to textarea
    this.editor.on("change", () => {
      this.textareaTarget.value = this.editor.getValue()
    })

    // Hide the original textarea
    this.textareaTarget.style.display = "none"
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
