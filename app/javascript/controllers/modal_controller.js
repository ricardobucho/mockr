import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(this.element);
    this.frameTarget = this.element.querySelector("turbo-frame#modal");
    
    // Watch for frame content changes to auto-close when emptied
    if (this.frameTarget) {
      this.observer = new MutationObserver(() => this.checkFrameContent());
      this.observer.observe(this.frameTarget, { childList: true, subtree: true });
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  checkFrameContent() {
    // Close modal if frame content is empty (after turbo stream update)
    if (this.frameTarget && this.frameTarget.innerHTML.trim() === "") {
      this.modal.hide();
    }
  }

  open() {
    if (!this.modal.isOpened) {
      this.modal.show();
    }
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide();
    }
  }
}
