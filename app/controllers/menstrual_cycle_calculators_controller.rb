class MenstrualCycleCalculatorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_menstrual_cycle_calculator, only: [:show, :edit, :update, :destroy]

  def index
    @menstrual_cycle_calculators = current_user.menstrual_cycle_calculators.order(created_at: :desc)
  end

  def show
  end

  def new
    @menstrual_cycle_calculator = current_user.menstrual_cycle_calculators.build
  end

  def create
    @menstrual_cycle_calculator = current_user.menstrual_cycle_calculators.build(menstrual_cycle_calculator_params)

    if @menstrual_cycle_calculator.save
      redirect_to @menstrual_cycle_calculator, notice: 'Calculadora de ciclo menstrual criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @menstrual_cycle_calculator.update(menstrual_cycle_calculator_params)
      redirect_to @menstrual_cycle_calculator, notice: 'Calculadora de ciclo menstrual atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @menstrual_cycle_calculator.destroy
    redirect_to menstrual_cycle_calculators_path, notice: 'Calculadora de ciclo menstrual removida com sucesso.'
  end

  private

  def set_menstrual_cycle_calculator
    @menstrual_cycle_calculator = current_user.menstrual_cycle_calculators.find(params[:id])
  end

  def menstrual_cycle_calculator_params
    params.require(:menstrual_cycle_calculator).permit(:last_period_date, :cycle_length, :period_duration, :notes, :symptoms)
  end
end
