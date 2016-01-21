class Product < ActiveRecord::Base
  belongs_to :site
  has_many :product_properties#, as: :properties
  validates :site, presence: true
  validates :path, presence: true

  attr_writer :url

  after_create -> (product) { FetchProductJob.perform_later(product)}

  def self.search(params)
    where(parsed: true)
    where(site_id: params[:site_id]) if params.has_key? :site_id
    where('title like ?', "%#{params[:title]}%") unless params[:title].nil?
    # products
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
