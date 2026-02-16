import "@hotwired/turbo-rails"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".toggle-password").forEach(toggle => {

    toggle.addEventListener("click", () => {
      const input = document.getElementById(toggle.dataset.target)
      if (!input) return

      const isPassword = input.type === "password"

      input.type = isPassword ? "text" : "password"
      toggle.textContent = isPassword ? "🙈" : "👁"
    })

  })
})
