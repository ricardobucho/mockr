import { Controller } from "@hotwired/stimulus";
import Prism from "prismjs";
import "prismjs/components/prism-markup";
import "prismjs/components/prism-json";

export default class extends Controller {
  connect() {
    console.log("Highlight controller connected", this.element);
    console.log("Prism:", Prism);
    console.log("Languages:", Prism.languages);
    Prism.highlightElement(this.element);
  }
}
