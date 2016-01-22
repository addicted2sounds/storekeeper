class Product < ActiveRecord::Base
  belongs_to :site
  has_many :product_properties#, as: :properties
  validates :site, presence: true
  validates :path, presence: true, uniqueness: {
    scope: :site_id, message: 'already exists'
  }

  attr_writer :url

  after_create -> (product) { FetchProductJob.perform_later(product)}

  def self.search(params)
    products = where(parsed: true, error: false)
    products = products.where(site_id: params[:site_id]) unless params[:site_id].nil?
    products = products.where('title like ?', "%#{params[:title]}%") unless params[:title].nil?
    products
  end

  def option(option)
    product_properties.where(product_option: option).first
  end

  def url
    @url ||= "http://#{site.url}#{path}"
  end

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
