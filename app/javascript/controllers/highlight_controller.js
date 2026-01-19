import { Controller } from "@hotwired/stimulus";
import Prism from "prismjs";
import "prismjs/components/prism-markup";
import "prismjs/components/prism-json";

export default class extends Controller {
  connect() {
    Prism.highlightElement(this.element);
  }
}
