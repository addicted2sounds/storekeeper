class CreateProductProperties < ActiveRecord::Migration
  def change
    create_table :product_properties do |t|
      t.references :product, index: true, foreign_key: true
      t.belongs_to :product_option, index: true, foreign_key: true
      t.string :name
      t.string :parsed_value

      t.timestamps null: false
    end
  end
end
