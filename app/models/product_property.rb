class ProductProperty < ActiveRecord::Base
  belongs_to :product
  belongs_to :product_option
end
