class Site < ActiveRecord::Base
  has_many :product_options
  validates :url, presence: true
end
