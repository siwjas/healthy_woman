class CreateArticlesCategorizations < ActiveRecord::Migration[8.0]
  def change
    create_table :articles_categorizations do |t|
      t.references :article, null: false, foreign_key: { to_table: :articles_articles }
      t.references :category, null: false, foreign_key: { to_table: :articles_categories }

      t.timestamps
    end

    # Adicionar índice único para evitar duplicações
    add_index :articles_categorizations, [:article_id, :category_id], unique: true

    # Adicionar coluna para marcar categoria principal (opcional)
    add_column :articles_categorizations, :is_primary, :boolean, default: false

    # Migrar dados existentes
    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO articles_categorizations (article_id, category_id, is_primary, created_at, updated_at)
          SELECT id, category_id, true, created_at, updated_at
          FROM articles_articles
        SQL
      end
    end

    # Remover a coluna category_id da tabela articles_articles
    # Comentado para ser executado em uma migração separada após testes
    # remove_reference :articles_articles, :category, foreign_key: true
  end
end
