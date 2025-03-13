class BmiCalculatorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bmi_calculator, only: [:show, :edit, :update, :destroy]

  def index
    @bmi_calculators = current_user.bmi_calculators.order(created_at: :desc)
  end

  def show
  end

  def new
    @bmi_calculator = current_user.bmi_calculators.build
  end

  def create
    @bmi_calculator = current_user.bmi_calculators.build(bmi_calculator_params)

    if @bmi_calculator.save
      redirect_to @bmi_calculator, notice: 'Calculadora de IMC criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bmi_calculator.update(bmi_calculator_params)
      redirect_to @bmi_calculator, notice: 'Calculadora de IMC atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @bmi_calculator.destroy
    redirect_to bmi_calculators_path, notice: 'Calculadora de IMC removida com sucesso.'
  end

  private

  def set_bmi_calculator
    @bmi_calculator = current_user.bmi_calculators.find(params[:id])
  end

  def bmi_calculator_params
    params.require(:bmi_calculator).permit(:weight, :height, :is_pregnant, :pre_pregnancy_weight, :weight_goal, :notes)
  end
end
