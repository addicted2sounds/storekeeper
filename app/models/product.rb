class Product < ActiveRecord::Base
  belongs_to :site
  validates :site, presence: true
  validates :path, presence: true

  def self.import(url)
    @url = url
    uri = URI(url)
    site = Site.find_by(url: uri.host)
    product = new(path: uri.path, site: site)
    if site.nil?
      product.errors.add  :site, 'Site is not supported'
    else
      product.save
    end
    product
  end
end
