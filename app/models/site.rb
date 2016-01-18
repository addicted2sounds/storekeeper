class Site < ActiveRecord::Base
  has_many :product_options
  validates :name, presence: true
  validates :url, presence: true
end
