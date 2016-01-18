class AddSelectorTypeToProductOptions < ActiveRecord::Migration
  def change
    add_column :product_options, :selector_type, :integer
  end
end
