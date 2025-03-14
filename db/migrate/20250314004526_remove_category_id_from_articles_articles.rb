class RemoveCategoryIdFromArticlesArticles < ActiveRecord::Migration[8.0]
  def change
    remove_reference :articles_articles, :category, foreign_key: { to_table: :articles_categories }
  end
end
