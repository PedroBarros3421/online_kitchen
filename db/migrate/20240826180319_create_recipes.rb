class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :chef, foreign_key: true
      t.timestamps
    end
  end
end
