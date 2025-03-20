# Ejected from `bullet_train-1.19.0/app/controllers/registrations_controller.rb`.

# i really, really wanted this controller in a namespace, but devise doesn't
# appear to support it. instead, i got the following error:
#
#   'Authentication::RegistrationsController' is not a supported controller name.
#   This can lead to potential routing problems.

class RegistrationsController < Devise::RegistrationsController
  include Registrations::ControllerBase

  # Adicionar os novos campos aos parâmetros permitidos
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:height, :is_pregnant, :first_name, :last_name, :time_zone])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:height, :is_pregnant, :first_name, :last_name, :time_zone])
  end
end
