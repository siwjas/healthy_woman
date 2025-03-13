class CreateArticlesArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles_articles do |t|
      t.references :category, null: false, foreign_key: {to_table: 'articles_categories'}
      t.string :title
      t.text :content
      t.string :published

      t.timestamps
    end
  end
end
