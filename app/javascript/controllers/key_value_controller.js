import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["rows", "row", "rowTemplate", "hiddenField", "empty", "keyInput", "valueInput", "handle"]
  static values = {
    fieldName: String
  }

  connect() {
    this.initSortable()
    this.updateEmptyState()
  }

  initSortable() {
    if (this.hasRowsTarget) {
      this.sortable = Sortable.create(this.rowsTarget, {
        handle: ".key-value-drag-handle",
        animation: 150,
        ghostClass: "key-value-row-ghost",
        onEnd: () => this.updateHiddenField()
      })
    }
  }

  addRow() {
    const template = this.rowTemplateTarget
    const clone = template.content.cloneNode(true)
    this.rowsTarget.appendChild(clone)
    this.updateEmptyState()
    this.updateHiddenField()

    // Focus the new key input
    const rows = this.rowTargets
    const lastRow = rows[rows.length - 1]
    if (lastRow) {
      const keyInput = lastRow.querySelector(".key-value-key-input")
      if (keyInput) keyInput.focus()
    }
  }

  removeRow(event) {
    const row = event.target.closest(".key-value-row")
    if (row) {
      row.remove()
      this.updateEmptyState()
      this.updateHiddenField()
    }
  }

  updateHiddenField() {
    const data = {}
    
    this.rowTargets.forEach(row => {
      const keyInput = row.querySelector(".key-value-key-input")
      const valueInput = row.querySelector(".key-value-value-input")
      
      if (keyInput && valueInput) {
        const key = keyInput.value.trim()
        const value = valueInput.value
        
        if (key !== "") {
          data[key] = value
        }
      }
    })

    this.hiddenFieldTarget.value = JSON.stringify(data)
  }

  updateEmptyState() {
    if (this.hasEmptyTarget) {
      const hasRows = this.rowTargets.length > 0
      this.emptyTarget.style.display = hasRows ? "none" : "block"
    }
  }
}
