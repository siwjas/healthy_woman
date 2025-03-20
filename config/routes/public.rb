collection_actions = [:index, :new, :create]

# 🚅 Don't remove this block, it will break Super Scaffolding.
begin
  namespace :public do
    shallow do
      resources :teams do
        resources :bmi_calculators, concerns: [:sortable]
      end
    end
  end
end
