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
    site: site, name: 'availability', selector_type: :regexp,
    selector: '"itemAvailability":({.+?})'
  },
  {
    site: site, name: 'shipping_weight', selector_type: :regexp,
    selector: '"Dotcom Shipping Carton Gross Weight \(lb\)","value":"(.*?)"'
  },
  {
    site: site, name: 'country_of_origin', selector_type: :regexp,
    selector: '"COUNTRY OF ORIGIN","value":"(.*?)"'
  },
  {
    site: site, name: 'ship_to_home', selector_type: :regexp,
    selector: '"shipToHome":{"status":(.*?)}'
  },
  {
    site: site, name: 'rating', selector_type: :regexp,
    selector: '"averageRating":"(.+?)"'
  },
  {
    site: site, name: 'upc', selector_type: :regexp,
    selector: '"upc":"(.+?)"'
  },
])
site = Site.create url: 'www.lowes.com', name: 'Lowes'
ProductOption.create([
  { site: site, name: 'title', selector: '.itemInfo h1' },
  { site: site, name: 'price', selector: '.mystore-item-price' },
  { site: site, name: 'item_num', selector: '#ItemNumber' },
  { site: site, name: 'model_num', selector: '#ModelNumber' },
  {
    site: site, name: 'rating', selector_type: :xpath,
    selector: '//*[@class="productRating"]/img/@alt'
  },
  { site: site, name: 'description', selector: '#description-tab' },
  { site: site, name: 'specifications', selector: '#specifications-tab' },
])