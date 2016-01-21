class AddErrorToProducts < ActiveRecord::Migration
  def change
    add_column :products, :error, :boolean
  end
end
