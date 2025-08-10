import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["q", "minLevel"]

  connect() {
    this.timer = null
  }

  debounced() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.submit(), 250)
  }

  submit() {
    const params = new URLSearchParams()
    if (this.qTarget.value) params.set('q', this.qTarget.value)
    if (this.minLevelTarget.value) params.set('min_level', this.minLevelTarget.value)
    Turbo.visit(`/products?${params.toString()}`, { frame: 'products_list' })
  }
}
