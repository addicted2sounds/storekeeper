class Product < ActiveRecord::Base
  belongs_to :site
  validates :path, presence: true
end
