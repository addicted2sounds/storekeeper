# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

site = Site.create url: 'www.homedepot.com', name: 'Home Depot'
ProductOption.create([
  { site: site, name: 'title', selector: '.product_title' },
  { site: site, name: 'price', selector: '[itemprop="price"]' },
  { site: site, name: 'model_num', selector: '[itemprop="model"]' },
  { site: site, name: 'brand', selector: '[itemprop="brand"]' },
  { site: site, name: 'description', selector: '[itemprop="description"]' },
  { site: site, name: 'specifications', selector: '#specsContainer' },
  {
    site: site, name: 'width', selector_type: :xpath,
    selector: '//td/div[contains(.,"Product Width")]/following::td[1]/div'
  },
  {
    site: site, name: 'height', selector_type: :xpath,
    selector: '//td/div[contains(.,"Product Height")]/following::td[1]/div'
  },
  {
    site: site, name: 'depth', selector_type: :xpath,
    selector: '//td/div[contains(.,"Product Depth")]/following::td[1]/div'
  },
  {
    site: site, name: 'weight', selector: '[itemprop="weight"]'
  },
  {
    site: site, name: 'original_price', selector_type: :regexp,
    selector: '"originalPrice":([\d.]+)'
  },
  {
    site: site, name: 'special_price', selector_type: :regexp,
    selector: '"originalPrice":([\d.]+)'
  },
  {
    site: site, name: 'rating', selector_type: :regexp,
    selector: '"averageRating":"(.+?)"'
  },
  {
    site: site, name: 'upc', selector_type: :regexp,
    selector: '"upc":"(.+?)"'
  },
  # { site: site, name: 'availability', selector: '.product_details.modelNo' },
  # { site: site, name: 'shipping_weight', selector: '.product_details.modelNo' },
  # { site: site, name: 'country_of_origin', selector: '.product_details.modelNo' },
  # { site: site, name: 'rating', selector: '.product_details.modelNo' },
  # { site: site, name: 'ship_to_home', selector: '.product_details.modelNo' },
  # { site: site, name: 'shipping_cost', selector: '.product_details.modelNo' },
  # { site: site, name: 'upc', selector: '.product_details.modelNo' },
])