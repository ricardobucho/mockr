import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

// Connects to data-controller="search-input"
export default class extends Controller {
  connect() {}

  clearSearch() {
    this.element.value = "";
  }
}
