import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static values = { tooltipNodes: { type: Array, default: [] } };

  connect() {
    document.addEventListener(
      "turbo:frame-load",
      this.enableTooltips.bind(this)
    );
  }

  enableTooltips() {
    const documentTooltipNodes = document.querySelectorAll(
      '[data-bs-toggle="tooltip"]'
    );

    const tooltipNodes = [...documentTooltipNodes].filter(
      (tooltipNode) => !this.tooltipNodesValue.includes(tooltipNode)
    );

    this.tooltipNodesValue.push(...tooltipNodes);

    tooltipNodes.map(
      (tooltipNode) =>
        new bootstrap.Tooltip(tooltipNode, {
          trigger: "hover",
        })
    );
  }
}
