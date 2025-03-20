import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bmi-calculator"
export default class extends Controller {
  static targets = ["weight", "height", "isPregnant", "prePregnancyWeight", "result"]
  static classes = ["flex"]

  connect() {
    console.log("BMI Calculator controller connected!")
    console.log("Form:", this.element.querySelector('form'))
    console.log("Form data-action:", this.element.querySelector('form').dataset.action)
    console.log("Submit button:", this.element.querySelector('input[type="submit"]'))
    console.log("Targets found:", {
      weight: this.hasWeightTarget,
      height: this.hasHeightTarget,
      result: this.hasResultTarget
    })
    
    // Inicializa o Local Storage se estiver vazio
    if (!localStorage.getItem('lastBmiResult')) {
      console.log("Initializing Local Storage...")
      localStorage.setItem('lastBmiResult', 'Insira seu peso e altura para calcular o IMC')
    }
    
    this.loadLastResult()
  }

  // Carrega o último resultado do Local Storage
  loadLastResult() {
    console.log("Loading last result...")
    const lastResult = localStorage.getItem('lastBmiResult')
    if (lastResult) {
      this.resultTarget.textContent = lastResult
      console.log("Loaded result:", lastResult)
    }
  }

  // Salva o resultado no Local Storage
  saveResult(result) {
    console.log("Saving result:", result)
    localStorage.setItem('lastBmiResult', result)
  }

  // Mostra/esconde campos específicos para gestantes
  togglePregnantFields() {
    const isPregnantFields = document.querySelector(".is-pregnant-fields")
    isPregnantFields.classList.toggle("hidden", !this.isPregnantTarget.checked)
  }

  validateInput(event) {
    console.log("Input changed:", event.target.value)
    const value = parseFloat(event.target.value)
    if (value <= 0) {
      event.target.classList.add('border-red-500')
    } else {
      event.target.classList.remove('border-red-500')
    }
  }

  calculate(event) {
    console.log("Calculate called!", event)
    event.preventDefault()
    
    const weight = parseFloat(this.weightTarget.value)
    const height = parseFloat(this.heightTarget.value)
    
    console.log("Calculating with:", { weight, height })
    
    if (!weight || !height || weight <= 0 || height <= 0) {
      this.resultTarget.textContent = "Por favor, insira valores válidos"
      return
    }

    const bmi = weight / (height * height)
    let result = `Seu IMC é: ${bmi.toFixed(2)} - `
    
    if (bmi < 18.5) {
      result += "Abaixo do peso"
    } else if (bmi < 24.9) {
      result += "Peso normal"
    } else if (bmi < 29.9) {
      result += "Sobrepeso"
    } else if (bmi < 34.9) {
      result += "Obesidade grau 1"
    } else if (bmi < 39.9) {
      result += "Obesidade grau 2"
    } else {
      result += "Obesidade grau 3"
    }

    console.log("Result:", result)
    this.resultTarget.textContent = result
    this.saveResult(result)
  }
}
