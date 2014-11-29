class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :description
      t.integer :quantity
      t.float :price
      t.references :installation, index: true

      t.timestamps null: false
    end
  end
end
