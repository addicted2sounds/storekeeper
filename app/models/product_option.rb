class ProductOption < ActiveRecord::Base
  belongs_to :site
  enum selector_type: [:css, :xpath]
  validates :name, presence: true
end
