# Implementação de Sistema de Roles no Bullet Train

## Visão Geral

Este documento detalha a implementação de um sistema de roles (funções) no Bullet Train para o projeto "Vida de Mulher", estabelecendo três níveis de acesso:

Admin: Acesso total, pode criar outros usuários e atribuir roles

Publisher: Acesso ao painel administrativo, gerencia Articles e Categories

User: Acesso apenas às views públicas, mesmo quando autenticado

## Arquivos a Serem Criados/Modificados

### Modelos e Migrações

1. Criar modelo Role

```ruby
*# app/models/role.rb*

class Role < ApplicationRecord
	has_many :users
	validates :name, presence: true, uniqueness: true
end
```

Migração para criar tabela roles

  *# db/migrate/YYYYMMDDHHMMSS_create_roles.rb*

  class CreateRoles < ActiveRecord::Migration[8.0]

   def change

​    create_table :roles do |t|

​     t.string :name, null: false

​     t.string :description

​     

​     t.timestamps

​    end

​    

​    add_index :roles, :name, unique: true

   end

  end

Modificar modelo User

  *# app/models/user.rb*

  class User < ApplicationRecord

   *# Adicionar esta linha*

   belongs_to :role

   

   *# Métodos auxiliares para verificar roles*

   def admin?

​    role.name == 'admin'

   end

   

   def publisher?

​    role.name == 'publisher'

   end

   

   def regular_user?

​    role.name == 'user'

   end

   

   *# Restante do modelo...*

  end

4. Migração para adicionar role_id aos usuários

  *# db/migrate/YYYYMMDDHHMMSS_add_role_to_users.rb*

  class AddRoleToUsers < ActiveRecord::Migration[8.0]

   def change

​    add_reference :users, :role, foreign_key: true

   end

  end

### Configuração Inicial

Modificar seeds.rb para criar roles e admin inicial

  *# db/seeds.rb*

  *# Criar roles*

  admin_role = Role.create!(name: 'admin', description: 'Acesso total ao sistema')

  publisher_role = Role.create!(name: 'publisher', description: 'Gerencia conteúdo')

  user_role = Role.create!(name: 'user', description: 'Acesso básico')

  *# Criar admin inicial*

  admin = User.new(

   email: 'admin@example.com',

   password: 'password123',

   password_confirmation: 'password123',

   first_name: 'Admin',

   last_name: 'User',

   role: admin_role

  )

  admin.skip_confirmation! if admin.respond_to?(:skip_confirmation!)

  admin.save!

  *# Criar time para o admin*

  team = Team.create!(name: 'Administração')

  Membership.create!(user: admin, team: team, role: 'admin')

### Autorização e Controle de Acesso

Configurar CanCanCan para autorização

  *# app/models/ability.rb*

  class Ability

   include CanCan::Ability

   def initialize(*user*)

​    *# Usuário não logado*

​    return unless user.present?

​    

​    *# Permissões para usuários regulares (role: user)*

​    if user.regular_user?

​     *# Não tem acesso ao painel administrativo*

​     *# Apenas permissões básicas para seu próprio* *perfil*

​     can :read, User, id: user.id

​     can :update, User, id: user.id

​    end

​    

​    *# Permissões para publishers*

​    if user.publisher?

​     *# Acesso ao painel administrativo*

​     can :access, :account_dashboard

​     

​     *# Gerenciamento de conteúdo*

​     can :manage, Articles::Article, team_id: user.team_ids

​     can :manage, Articles::Category, team_id: user.team_ids

​     

​     *# Não pode gerenciar usuários*

​     cannot :manage, User

​     cannot :manage, Team

​     cannot :manage, Membership

​    end

​    

​    *# Permissões para admins*

​    if user.admin?

​     *# Acesso total*

​     can :manage, :all

​    end

   end

  end

Modificar ApplicationController para verificar acesso ao painel

  *# app/controllers/account/application_controller.r**b*

  class Account::ApplicationController < ApplicationController

   before_action :authenticate_user!

   before_action :authorize_account_access!

   

   private

   

   def authorize_account_access!

​    unless current_user.admin? || current_user.publisher?

​     redirect_to root_path, alert: "Você não tem permissão para acessar esta área."

​    end

   end

  end

Modificar controller de registro para atribuir role padrão

  *# app/controllers/users/registrations_controller.r**b*

  class Users::RegistrationsController < Devise::RegistrationsController

   before_action :configure_sign_up_params, only: [:create]

   

   def create

​    super do |user|

​     *# Atribuir role padrão 'user' para novos registros*

​     user.role = Role.find_by(name: 'user')

​    end

   end

   

   *# Restante do controller...*

  end

### Interface de Gerenciamento de Roles

Adicionar métodos ao UsersController para gerenciar roles

  *# app/controllers/account/users_controller.rb*

  *# Adicionar métodos para gerenciar roles*

  def edit_role

   @user = User.find(params[:id])

   authorize! :manage, @user

   @roles = Role.all

  end

  def update_role

   @user = User.find(params[:id])

   authorize! :manage, @user

   

   if @user.update(role_id: params[:user][:role_id])

​    redirect_to account_user_path(@user), notice: "Role atualizado com sucesso."

   else

​    @roles = Role.all

​    render :edit_role

   end

  end

Criar view para edição de role

  <!-- app/views/account/users/edit_role.html.erb -->

    <div class="container mx-auto px-4 py-8">

   <h1 class="text-2xl font-bold mb-6">Editar Role do Usuário</h1>

   

   <%= form_with model: @user, url: update_role_account_user_path(@user), method: :patch do |f| %>

        <div class="mb-4">

​     <%= f.label :role_id, "Role", class: "block text-gray-700 font-bold mb-2" %>

​     <%= f.collection_select :role_id, @roles, :id, :name, {}, class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" %>

​    </div>

​    

​    <%= f.submit "Atualizar Role", class: "bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline" %>

   <% end %>

  </div>

### Rotas e Navegação

Adicionar rotas para gerenciamento de roles

  *# config/routes.rb*

  namespace :account do

   resources :users do

​    member do

​     get :edit_role

​     patch :update_role

​    end

   end

  end

Modificar layout para mostrar/esconder elementos baseado em role

  <!-- app/views/layouts/application.html.erb -->

  <% if user_signed_in? && (current_user.admin? || current_user.publisher?) %>

   <%= link_to "Painel Administrativo", account_dashboard_path, class: "..." %>

  <% end %>

### Dashboard Público para Usuários Regulares

Criar controller para dashboard público

  *# app/controllers/public/dashboard_controller.rb*

  class Public::DashboardController < Public::ApplicationController

   before_action :authenticate_user!

   

   def index

​    @recent_pregnancy_calculators = current_user.pregnancy_calculators.order(created_at: :desc).limit(3)

​    @recent_menstrual_cycle_calculators = current_user.menstrual_cycle_calculators.order(created_at: :desc).limit(3)

​    @recent_bmi_calculators = current_user.bmi_calculators.order(created_at: :desc).limit(3)

   end

  end

Criar view para dashboard público

  <!-- app/views/public/dashboard/index.html.erb -->

    <div class="container mx-auto px-4 py-8">

   <h1 class="text-2xl font-bold mb-6">Seu Dashboard</h1>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

​    <!-- Calculadora de Gravidez -->

        <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">

​     <h2 class="text-xl font-bold mb-4">Cálculos de Gravidez Recentes</h2>

​     <% if @recent_pregnancy_calculators.any? %>

​      <!-- Lista de cálculos -->

​     <% else %>

            <p class="text-gray-500">Você ainda não tem cálculos de gravidez.</p>

​     <% end %>

​    </div>

​    <!-- Outras calculadoras... -->

   </div>

  </div>

### Redirecionamento e Navegação

Modificar redirecionamento após login

  *# app/controllers/application_controller.rb*

  def after_sign_in_path_for(*resource*)

   if resource.admin? || resource.publisher?

​    account_dashboard_path

   else

​    public_dashboard_path

   end

  end

## Considerações para Implementação

Migração de Dados Existentes: Se já existirem usuários, será necessário atribuir roles a eles:

  *# db/migrate/YYYYMMDDHHMMSS_assign_default_role_to**_existing_users.rb*

  class AssignDefaultRoleToExistingUsers < ActiveRecord::Migration[8.0]

   def up

​    user_role = Role.find_by(name: 'user')

​    User.where(role_id: nil).update_all(role_id: user_role.id)

   end

   

   def down

​    *# Não é necessário fazer nada aqui*

   end

  end

Testes: Criar testes para verificar que as permissões estão funcionando corretamente.

Adaptação de Views Existentes: As views existentes (como as listadas em <maybe_relevant_files>) precisarão ser adaptadas para considerar as permissões baseadas em roles.

Documentação: Manter documentação atualizada sobre o sistema de roles para facilitar a manutenção futura.

## Conclusão

Esta implementação fornece uma estrutura sólida para gerenciar diferentes níveis de acesso no aplicativo "Vida de Mulher", mantendo a separação entre usuários regulares e administrativos, conforme a regra de negócio especificada.