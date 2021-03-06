class ProductOption < ActiveRecord::Base
  belongs_to :site
  enum selector_type: [:css, :xpath, :regexp]
  validates :name, presence: true
end
