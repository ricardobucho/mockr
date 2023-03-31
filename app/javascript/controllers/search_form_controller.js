import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

// Connects to data-controller="search-form"
export default class extends Controller {
  connect() {}

  submit() {
    Rails.fire(this.element, "submit");
  }
}
