import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ["textInput"];

  connect() {}

  submit() {
    Rails.fire(this.element, "submit");
  }

  clear(event) {
    if (this.textInputTarget.value === "") {
      return;
    }

    this.textInputTarget.value = "";
    Rails.fire(this.element, "submit");
  }
}
