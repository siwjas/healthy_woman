# Controle de Acesso e Roles no Bullet Train

## Visão Geral

Documentação para implementação futura do sistema de controle de acesso diferenciado entre usuários comuns e administrativos.

## Estrutura Proposta

### 1. Roles de Usuário

```ruby
enum role: {
  user: 0,      # Usuário comum - acesso apenas ao Public
  publisher: 1, # Editor - acesso ao Account para gerenciar artigos
  admin: 2      # Admin - acesso total ao Account
}
```

### 2. Fluxos de Acesso

- **Usuários Comuns (role: user)**
  - Acesso apenas ao namespace `Public`
  - Dashboard personalizado em `public/dashboard`
  - Mantém acesso ao seu `Team` pessoal
  - Visualiza apenas seus próprios dados

- **Publishers (role: publisher)**
  - Acesso ao painel Account
  - Gerenciamento de artigos e categorias
  - Não podem criar outros usuários

- **Admins (role: admin)**
  - Acesso total ao painel Account
  - Podem criar e gerenciar outros usuários
  - Atribuição de roles

### 3. Implementação Necessária

1. **Migração para Adicionar Role**

```ruby
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0
  end
end
```

2. **Controle de Acesso no Account**

```ruby
class Account::ApplicationController < ApplicationController
  before_action :check_admin_access
  
  private
  
  def check_admin_access
    unless current_user&.admin? || current_user&.publisher?
      redirect_to public_dashboard_path
    end
  end
end
```

3. **Redirecionamento Pós-Login**

```ruby
def after_sign_in_path_for(resource)
  if resource.admin? || resource.publisher?
    account_dashboard_path
  else
    public_dashboard_path
  end
end
```

4. **Rotas**

```ruby
# config/routes.rb
scope module: "public" do
  # Dashboard público autenticado
  authenticate :user do
    get 'dashboard', to: 'dashboard#index'
  end
end

namespace :account do
  authenticate :user, lambda { |u| u.admin? || u.publisher? } do
    # rotas administrativas
  end
end
```

### 4. Considerações de Implementação

1. **Seed Inicial**

- Criar admin inicial via `seeds.rb`
- Não permitir criação de admins via interface

2. **UI/UX**

- Adaptar menus baseado no role
- Mensagens claras sobre restrições de acesso
- Redirecionamentos apropriados

3. **Segurança**

- Verificações em múltiplas camadas (controller, model, view)
- Logs de tentativas de acesso não autorizado
- Validações no modelo para mudanças de role

### 5. Próximos Passos

1. Criar migração para role
2. Implementar lógica básica de roles
3. Adaptar controllers e views
4. Testar fluxos de acesso
5. Implementar UI específica por role

## Observações

- Manter compatibilidade com estrutura de Teams do Bullet Train
- Considerar futuras necessidades de expansão de roles
- Documentar mudanças para equipe
