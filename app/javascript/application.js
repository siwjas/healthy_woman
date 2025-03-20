console.log("Application.js starting...")

// Inicializar Stimulus primeiro
import { Application } from "@hotwired/stimulus"
const application = Application.start()
console.log("Stimulus application started:", application)

// Registrar controllers
import "./controllers"

// Depois outros imports
import "@hotwired/turbo-rails"
import "./support/jstz"
import "@bullet-train/bullet-train"
import "@bullet-train/bullet-train-sortable"

// Exportar application para uso global
window.Stimulus = application

// 🚫 DEFAULT BULLET TRAIN INCLUDES
// This section represents the default settings for a Bullet Train application. Your own includes should be specified
// at the end of the file. This helps avoid merge conflicts in the future, should we need to change our own includes.

// ✅ YOUR APPLICATION'S INCLUDES
// If you need to customize your application's includes, this is the place to do it. This helps avoid merge
// conflicts in the future when Rails or Bullet Train update their own default includes.

console.log("Application.js loaded!")

// Verificar se o Stimulus está disponível
document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM loaded, checking Stimulus...")
  if (window.Stimulus) {
    console.log("Stimulus is available globally")
  } else {
    console.log("Warning: Stimulus is not available globally")
  }
})
