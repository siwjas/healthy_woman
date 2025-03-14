json.extract! article,
  :id,
  :team_id,
  :title,
  :published,
  :cover_image,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at

# Incluir as categorias associadas
json.categories article.categories do |category|
  json.extract! category, :id, :name
end

# 🚅 super scaffolding will insert file-related logic above this line.
