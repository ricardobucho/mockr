import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

const STORAGE_KEY = "mockr_active_client_id"

export default class extends Controller {
  static targets = ["tab", "pane"]

  connect() {
    this.restoreActiveTab()
    this.bindTabEvents()
  }

  bindTabEvents() {
    // Listen for Bootstrap tab show events to save the active tab
    this.tabTargets.forEach(tab => {
      tab.addEventListener("shown.bs.tab", (event) => {
        const clientId = this.extractClientId(event.target)
        if (clientId) {
          this.saveActiveTab(clientId)
        }
      })
    })
  }

  restoreActiveTab() {
    const savedClientId = localStorage.getItem(STORAGE_KEY)
    if (!savedClientId) return

    const tab = this.tabTargets.find(t => this.extractClientId(t) === savedClientId)
    if (tab) {
      // Use Bootstrap's tab API to switch
      const bsTab = new bootstrap.Tab(tab)
      bsTab.show()
    }
  }

  saveActiveTab(clientId) {
    localStorage.setItem(STORAGE_KEY, clientId)
  }

  extractClientId(tabElement) {
    // Extract client ID from the tab's data-bs-target="#pills-{id}"
    const target = tabElement.getAttribute("data-bs-target")
    if (target) {
      const match = target.match(/pills-(\d+)/)
      return match ? match[1] : null
    }
    return null
  }
}
