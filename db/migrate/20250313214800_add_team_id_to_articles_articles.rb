class AddTeamIdToArticlesArticles < ActiveRecord::Migration[8.0]
  def change
    # Adicionar coluna team_id
    add_reference :articles_articles, :team, foreign_key: true
    
    # Preencher a coluna team_id com base na categoria atual
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE articles_articles
          SET team_id = (
            SELECT team_id 
            FROM articles_categories 
            WHERE articles_categories.id = articles_articles.category_id
          )
        SQL
      end
    end
    
    # Tornar a coluna team_id obrigatória
    change_column_null :articles_articles, :team_id, false
  end
end
