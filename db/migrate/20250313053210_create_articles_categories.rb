class CreateArticlesCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :articles_categories do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
