class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.references :site, index: true, foreign_key: true
      t.string :name
      t.string :selector

      t.timestamps null: false
    end
  end
end
