import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["q", "minLevel", "tag"]

  connect() {
    this.timer = null
  }

  debounced() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.submit(), 250)
  }

  submit() {
    const params = new URLSearchParams()
    // Preserve existing query params from current URL
    const current = new URL(window.location.href)
    current.searchParams.forEach((v, k) => {
      if (!['q', 'min_level', 'tag_ids[]', 'tag_ids', 'page'].includes(k)) {
        params.set(k, v)
      }
    })

    if (this.hasQTarget && this.qTarget.value) params.set('q', this.qTarget.value)
    if (this.hasMinLevelTarget && this.minLevelTarget.value) params.set('min_level', this.minLevelTarget.value)

    // Collect selected tags
    if (this.hasTagTarget) {
      const selected = this.tagTargets.filter(t => t.checked).map(t => t.value)
      selected.forEach(id => params.append('tag_ids[]', id))
    }

    Turbo.visit(`/products?${params.toString()}`, { frame: 'products_list' })
  }
}
