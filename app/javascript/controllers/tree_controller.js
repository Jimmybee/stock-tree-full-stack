import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["children", "toggle"]

  toggle(event) {
    event.preventDefault()
    const children = event.currentTarget.closest('li').querySelector('[data-tree-target="children"]')
    if (!children) return
    children.classList.toggle('hidden')
    event.currentTarget.textContent = children.classList.contains('hidden') ? '▸' : '▾'
  }
}
