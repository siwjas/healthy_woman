import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Verificar se o usuário acabou de fazer login
    if (document.body.dataset.userAuthenticated === "true") {
      this.migrateLocalStorageData()
    }
  }
  
  migrateLocalStorageData() {
    // Verificar se há dados para migrar
    const pregnancyData = localStorage.getItem('lastPregnancyCalculation')
    const menstrualCycleData = localStorage.getItem('lastMenstrualCycleCalculation')
    const bmiData = localStorage.getItem('lastBmiCalculation')
    
    if (pregnancyData || menstrualCycleData || bmiData) {
      // Enviar dados para o servidor
      fetch('/account/migrate_calculator_data', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          pregnancy_data: pregnancyData ? JSON.parse(pregnancyData) : null,
          menstrual_cycle_data: menstrualCycleData ? JSON.parse(menstrualCycleData) : null,
          bmi_data: bmiData ? JSON.parse(bmiData) : null
        })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // Limpar dados do LocalStorage após migração bem-sucedida
          localStorage.removeItem('lastPregnancyCalculation')
          localStorage.removeItem('lastMenstrualCycleCalculation')
          localStorage.removeItem('lastBmiCalculation')
          
          // Mostrar mensagem de sucesso
          console.log('Dados migrados com sucesso!')
        }
      })
      .catch(error => console.error('Erro ao migrar dados:', error))
    }
  }
} 