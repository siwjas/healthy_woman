import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "result", "lastCalculation"]
  
  connect() {
    this.loadLastCalculation()
  }
  
  // Salva o resultado no LocalStorage quando o formulário é enviado
  saveCalculation(event) {
    event.preventDefault()
    
    const formData = new FormData(this.formTarget)
    const lastMenstrualPeriodDate = formData.get("pregnancy_calculator[last_menstrual_period_date]")
    
    // Realizar cálculos no lado do cliente
    const dueDate = this.calculateDueDate(lastMenstrualPeriodDate)
    const { weeks, days } = this.calculateGestationalAge(lastMenstrualPeriodDate)
    
    // Criar objeto com os resultados
    const calculationResult = {
      lastMenstrualPeriodDate,
      dueDate: dueDate.toISOString().split('T')[0],
      weeks,
      days,
      timestamp: new Date().toISOString()
    }
    
    // Salvar no LocalStorage
    localStorage.setItem('lastPregnancyCalculation', JSON.stringify(calculationResult))
    
    // Atualizar a interface
    this.displayResult(calculationResult)
  }
  
  // Carrega o último cálculo do LocalStorage
  loadLastCalculation() {
    const savedData = localStorage.getItem('lastPregnancyCalculation')
    
    if (savedData && this.hasLastCalculationTarget) {
      const calculationResult = JSON.parse(savedData)
      this.displayLastCalculation(calculationResult)
    }
  }
  
  // Exibe o resultado atual
  displayResult(result) {
    if (this.hasResultTarget) {
      this.resultTarget.innerHTML = `
        <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <h2 class="text-xl font-bold mb-4">Resultado do Cálculo</h2>
          <div class="mb-4">
            <p class="text-gray-700">Data da última menstruação: ${new Date(result.lastMenstrualPeriodDate).toLocaleDateString()}</p>
            <p class="text-gray-700">Data provável do parto: ${new Date(result.dueDate).toLocaleDateString()}</p>
            <p class="text-gray-700">Idade gestacional: ${result.weeks} semanas e ${result.days} dias</p>
          </div>
          <div class="mt-6 text-center">
            <p class="text-gray-600">Para acessar seu histórico completo de cálculos:</p>
            <a href="/users/sign_in" class="mt-2 inline-block bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
              Faça login ou crie uma conta
            </a>
          </div>
        </div>
      `
    }
  }
  
  // Exibe o último cálculo salvo
  displayLastCalculation(result) {
    if (this.hasLastCalculationTarget) {
      this.lastCalculationTarget.innerHTML = `
        <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <h2 class="text-xl font-bold mb-4">Seu último cálculo</h2>
          <div class="mb-4">
            <p class="text-gray-700">Data da última menstruação: ${new Date(result.lastMenstrualPeriodDate).toLocaleDateString()}</p>
            <p class="text-gray-700">Data provável do parto: ${new Date(result.dueDate).toLocaleDateString()}</p>
            <p class="text-gray-700">Idade gestacional: ${result.weeks} semanas e ${result.days} dias</p>
            <p class="text-gray-500 text-sm mt-2">Calculado em: ${new Date(result.timestamp).toLocaleString()}</p>
          </div>
        </div>
      `
    }
  }
  
  // Calcula a data provável do parto (280 dias após a última menstruação)
  calculateDueDate(lastMenstrualPeriodDate) {
    const date = new Date(lastMenstrualPeriodDate)
    return new Date(date.setDate(date.getDate() + 280))
  }
  
  // Calcula a idade gestacional em semanas e dias
  calculateGestationalAge(lastMenstrualPeriodDate) {
    const today = new Date()
    const lmpDate = new Date(lastMenstrualPeriodDate)
    const diffTime = Math.abs(today - lmpDate)
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
    
    return {
      weeks: Math.floor(diffDays / 7),
      days: diffDays % 7
    }
  }
} 