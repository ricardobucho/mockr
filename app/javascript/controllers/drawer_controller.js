import { Controller } from "@hotwired/stimulus"

/**
 * Drawer Controller - Multi-panel stacking architecture
 * 
 * Each navigation creates a new panel instance. Panels stack visually
 * with the turbo frame moving between them. Back reveals previous panel
 * and re-fetches for fresh data.
 */
export default class extends Controller {
  static targets = ["backdrop", "container"]

  connect() {
    this.panels = []      // Array of panel DOM elements
    this.urlStack = []    // URLs for back navigation
    this.currentUrl = null
    
    // Create the turbo frame element (moves between panels)
    this.frame = document.createElement('turbo-frame')
    this.frame.id = 'drawer'
    this.frame.innerHTML = this.loadingHTML()
    
    document.addEventListener("click", this.handleClick.bind(this))
    this.frame.addEventListener("turbo:frame-load", this.handleFrameLoad.bind(this))
    document.addEventListener("turbo:before-stream-render", this.handleStreamRender.bind(this))
    document.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleClick.bind(this))
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
    document.removeEventListener("turbo:before-stream-render", this.handleStreamRender.bind(this))
  }

  handleClick(event) {
    const link = event.target.closest('a[data-turbo-frame="drawer"]')
    if (!link) return
    
    event.preventDefault()
    this.navigateTo(link.href)
  }

  handleFrameLoad(event) {
    if (event.target.id !== "drawer") return
    // Frame loaded - panel is already open and animated
  }

  handleStreamRender(event) {
    const stream = event.target
    if (stream.getAttribute("target") !== "drawer") return
    
    if (stream.getAttribute("action") === "update") {
      const template = stream.querySelector("template")
      if (template && template.innerHTML.trim() === "") {
        event.preventDefault()
        this.back()
      }
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape" && this.isOpen()) {
      event.preventDefault()
      this.back()
    }
  }

  navigateTo(url) {
    // If we have an active panel, stack it
    if (this.panels.length > 0) {
      this.stackCurrentPanel()
      this.urlStack.push(this.currentUrl)
    }
    
    // Create new panel with the frame
    const panel = this.createPanel()
    panel.appendChild(this.frame)
    this.containerTarget.appendChild(panel)
    this.panels.push(panel)
    
    // Load new content
    this.currentUrl = url
    this.frame.src = url
    
    // Open drawer and animate panel in
    // Double rAF ensures browser renders initial off-screen state before animating
    this.openDrawer()
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        panel.classList.add('open')
        this.updatePanelDepths()
      })
    })
  }

  stackCurrentPanel() {
    const panel = this.activePanel
    if (!panel) return
    
    // Clone frame content to static HTML
    const content = this.frame.innerHTML
    panel.innerHTML = content
    panel.classList.add('stacked')
  }

  back() {
    if (this.urlStack.length === 0) {
      this.close()
      return
    }
    
    const previousUrl = this.urlStack.pop()
    const closingPanel = this.panels.pop()
    const revealedPanel = this.activePanel
    
    // Clear the revealed panel's static content before adding frame
    revealedPanel.innerHTML = ''
    
    // Move frame to revealed panel and fetch fresh content
    revealedPanel.appendChild(this.frame)
    revealedPanel.classList.remove('stacked')
    this.currentUrl = previousUrl
    this.frame.src = previousUrl
    
    // Animate out closing panel
    closingPanel.classList.remove('open')
    closingPanel.classList.add('closing')
    
    this.updatePanelDepths()
    
    setTimeout(() => closingPanel.remove(), 300)
  }

  close() {
    // Animate all panels out
    this.panels.forEach(panel => {
      panel.classList.remove('open')
      panel.classList.add('closing')
    })
    
    this.backdropTarget.classList.remove("open")
    document.body.classList.remove("drawer-open")
    
    setTimeout(() => {
      this.panels.forEach(panel => panel.remove())
      this.panels = []
      this.urlStack = []
      this.currentUrl = null
      this.frame.innerHTML = this.loadingHTML()
      this.frame.removeAttribute("src")
    }, 300)
  }

  createPanel() {
    const panel = document.createElement('div')
    panel.className = 'drawer-panel'
    return panel
  }

  updatePanelDepths() {
    this.panels.forEach((panel, index) => {
      // Depth = index: 0 = backmost (widest), higher = frontmost (narrower)
      panel.dataset.depth = index
    })
    
    // Update back button visibility on active panel
    if (this.activePanel) {
      this.activePanel.dataset.hasHistory = this.urlStack.length > 0
    }
  }

  get activePanel() {
    return this.panels[this.panels.length - 1]
  }

  openDrawer() {
    document.body.classList.add("drawer-open")
    this.backdropTarget.classList.add("open")
  }

  isOpen() {
    return this.panels.length > 0
  }

  backdropClick(event) {
    // Do nothing - user requested no close on backdrop click
  }

  loadingHTML() {
    return `
      <div class="drawer-loading">
        <div class="drawer-loading-header">
          <div class="skeleton skeleton-text" style="width: 200px; height: 24px;"></div>
        </div>
        <div class="drawer-loading-body">
          <div class="skeleton skeleton-text" style="width: 100%; height: 16px; margin-bottom: 12px;"></div>
          <div class="skeleton skeleton-text" style="width: 80%; height: 16px; margin-bottom: 12px;"></div>
          <div class="skeleton skeleton-text" style="width: 60%; height: 16px;"></div>
        </div>
      </div>
    `
  }
}
