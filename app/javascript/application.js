import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

const tooltipTriggerList = document.querySelectorAll(
  '[data-bs-toggle="tooltip"]'
);

const tooltipList = [...tooltipTriggerList].map(
  (tooltipTriggerEl) =>
    new bootstrap.Tooltip(tooltipTriggerEl, {
      trigger: "hover",
    })
);
