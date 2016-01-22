class ChangeProductsErrorDefault < ActiveRecord::Migration
  def change
    change_column_default :products, :error, false
  end
end
