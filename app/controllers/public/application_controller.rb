class Public::ApplicationController < ApplicationController
  layout "public"
  
  # Não exigimos autenticação para controladores públicos
  skip_before_action :authenticate_user!, raise: false
end
