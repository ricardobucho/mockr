import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static targets = ["icon"];

  connect() {
    // Load saved preference, or detect system preference on first visit
    let theme = localStorage.getItem("theme");
    
    if (!theme) {
      // First visit - detect system preference
      theme = window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "dark"
        : "light";
    }
    
    this.currentTheme = theme;
    this.apply();
  }

  toggle() {
    // Simple toggle: light <-> dark
    this.currentTheme = this.currentTheme === "light" ? "dark" : "light";
    localStorage.setItem("theme", this.currentTheme);
    this.apply();
  }

  apply() {
    // Set on html element
    document.documentElement.setAttribute("data-bs-theme", this.currentTheme);
    
    // Update header button icon if present (dashboard)
    this.updateHeaderIcon();
  }

  updateHeaderIcon() {
    if (!this.hasIconTarget) return;
    
    // Check if this is the header button (has bi classes) vs iOS toggle (is thumb)
    if (this.iconTarget.classList.contains("theme-switch-thumb")) {
      // iOS toggle - no icon update needed, CSS handles it
      return;
    }
    
    const isLight = this.currentTheme === "light";
    
    // Remove both icons
    this.iconTarget.classList.remove("bi-sun-fill", "bi-moon-fill");
    
    // Add current icon (show sun in light mode, moon in dark mode)
    this.iconTarget.classList.add(isLight ? "bi-sun-fill" : "bi-moon-fill");
    
    // Update tooltip
    const button = this.iconTarget.closest("button");
    if (button) {
      const tooltip = isLight ? "Light Theme" : "Dark Theme";
      button.setAttribute("data-bs-title", tooltip);
      
      // Update Bootstrap tooltip instance if exists
      const tooltipInstance = bootstrap.Tooltip.getInstance(button);
      if (tooltipInstance) {
        tooltipInstance.setContent({ ".tooltip-inner": tooltip });
      }
    }
  }
}
