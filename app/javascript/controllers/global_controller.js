import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  connect() {
    // Enable tooltips on initial load (with small delay for turbo)
    setTimeout(() => this.enableTooltips(), 100);
    
    // Enable tooltips when turbo frames load
    document.addEventListener("turbo:frame-load", this.handleTurboLoad.bind(this));
    
    // Enable tooltips after turbo renders (for full page navigations)
    document.addEventListener("turbo:render", this.handleTurboLoad.bind(this));
    
    // Also listen for turbo:load for initial page loads
    document.addEventListener("turbo:load", this.handleTurboLoad.bind(this));
  }

  handleTurboLoad() {
    // Use setTimeout to ensure DOM is fully updated
    setTimeout(() => this.enableTooltips(), 50);
  }

  enableTooltips() {
    // Standard Bootstrap tooltips
    const tooltipNodes = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltipNodes.forEach((node) => {
      if (bootstrap.Tooltip.getInstance(node)) return;
      new bootstrap.Tooltip(node, { trigger: "hover" });
    });
    
    // Custom tooltips for elements that already use data-bs-toggle for something else
    const customTooltipNodes = document.querySelectorAll('[data-tooltip]');
    customTooltipNodes.forEach((node) => {
      if (bootstrap.Tooltip.getInstance(node)) return;
      new bootstrap.Tooltip(node, {
        trigger: "hover",
        title: node.getAttribute("data-tooltip"),
        placement: node.getAttribute("data-tooltip-placement") || "top",
      });
    });
  }
}
