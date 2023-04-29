import { Controller } from "@hotwired/stimulus";
import React from "react";
import { createRoot, render } from "react-dom/client";
import Editor from "../components/Editor";

export default class extends Controller {
  static values = { language: { type: String, default: "json" } };

  connect() {
    createRoot(this.element).render(
      <Editor code={this.element.innerHTML} language={this.languageValue} />
    );
  }
}
