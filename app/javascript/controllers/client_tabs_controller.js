import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

const STORAGE_KEY = "mockr_active_client_id"

export default class extends Controller {
  static targets = ["tab"]

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
          this.updateAddRequestButton(clientId)
        }
      })
    })
  }

  updateAddRequestButton(clientId) {
    const btn = document.querySelector('[data-client-tabs-target="addRequestBtn"]')
    if (btn) {
      btn.href = `/manage/clients/${clientId}/requests/new`
    }
  }

  restoreActiveTab() {
    const savedClientId = localStorage.getItem(STORAGE_KEY)
    if (!savedClientId) return

    const tab = this.tabTargets.find(t => this.extractClientId(t) === savedClientId)
    if (tab) {
      // Use Bootstrap's tab API to switch
      const bsTab = new bootstrap.Tab(tab)
      bsTab.show()
      this.updateAddRequestButton(savedClientId)
    }
  }

  saveActiveTab(clientId) {
    localStorage.setItem(STORAGE_KEY, clientId)
  }

  extractClientId(tabElement) {
    // Get client ID from data attribute or extract from target
    const clientId = tabElement.dataset.clientId
    if (clientId) return clientId
    
    const target = tabElement.getAttribute("data-bs-target")
    if (target) {
      const match = target.match(/pills-(\d+)/)
      return match ? match[1] : null
    }
    return null
  }
}
