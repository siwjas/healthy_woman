import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="pregnancy-calculator"
export default class extends Controller {
  connect() {
    console.log("Pregnancy Calculator controller connected")
  }
}
