class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :site, index: true, foreign_key: true
      t.string :path
      t.boolean :parsed, default: false

      t.timestamps null: false
    end
  end
end
