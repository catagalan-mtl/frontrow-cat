import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-comment"
export default class extends Controller {
  connect() {
    console.log("connected");
  }
}
