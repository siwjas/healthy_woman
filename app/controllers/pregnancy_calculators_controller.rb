class PregnancyCalculatorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pregnancy_calculator, only: [:show, :edit, :update, :destroy]

  def index
    @pregnancy_calculators = current_user.pregnancy_calculators.order(created_at: :desc)
  end

  def show
  end

  def new
    @pregnancy_calculator = current_user.pregnancy_calculators.build
  end

  def create
    @pregnancy_calculator = current_user.pregnancy_calculators.build(pregnancy_calculator_params)

    if @pregnancy_calculator.save
      redirect_to @pregnancy_calculator, notice: 'Calculadora de gravidez criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @pregnancy_calculator.update(pregnancy_calculator_params)
      redirect_to @pregnancy_calculator, notice: 'Calculadora de gravidez atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @pregnancy_calculator.destroy
    redirect_to pregnancy_calculators_path, notice: 'Calculadora de gravidez removida com sucesso.'
  end

  private

  def set_pregnancy_calculator
    @pregnancy_calculator = current_user.pregnancy_calculators.find(params[:id])
  end

  def pregnancy_calculator_params
    params.require(:pregnancy_calculator).permit(:last_menstrual_period_date, :notes)
  end
end
