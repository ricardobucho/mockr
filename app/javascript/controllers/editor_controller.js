import { Controller } from "@hotwired/stimulus";
import React from "react";
import { createRoot, render } from "react-dom/client";
import Editor from "../components/Editor";

export default class extends Controller {
  static values = { 
    language: { type: String, default: "json" },
    code: { type: String, default: "" }
  };

  connect() {
    // Use base64 encoded code value if present, otherwise fall back to textContent
    let code = "";
    if (this.hasCodeValue && this.codeValue) {
      try {
        code = atob(this.codeValue);
      } catch (e) {
        console.error("Failed to decode base64:", e);
        code = this.codeValue;
      }
    } else {
      code = this.element.textContent || "";
    }
    
    createRoot(this.element).render(
      <Editor code={code} language={this.languageValue} />
    );
  }
}
