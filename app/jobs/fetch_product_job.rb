# WebMock.allow_net_connect! unless Rails.env.test?
class FetchProductJob < ActiveJob::Base
  queue_as :default
  include Capybara::DSL

  def capybara_register_driver
    Capybara.register_driver :mechanize do |app|
      driver = Capybara::Mechanize::Driver.new(app)
      driver.configure do |agent|
        agent.user_agent_alias = 'Mac Safari'
      end
      driver
    end
    Capybara.app = 'ProductFetch'
  end

  def capybara_setup
    capybara_register_driver
    Capybara.configure do |config|
      config.run_server = false
      config.default_driver = :mechanize
    end
  end

  def parse_option(option)
    if option.selector_type.to_sym == :regexp
      value = page.body[/#{option.selector}/, 1]
    else
      value = page.find(option.selector_type.to_sym, option.selector).native.inner_html
    end
    value.gsub!(/\302\240/, ' ')
    value.strip
  end

  def parse_options(site, product)
    site.product_options.map do |option|
      value = parse_option(option) rescue nil
      if product.respond_to? option.name.to_sym
        product.attributes = {
          option.name.to_sym => value
        }
      else
        property = ProductProperty.find_or_create_by product_option: option,
                                                     product: product
        property.update name: option.name, parsed_value: value
      end
      [option.name, value]
    end.to_h.symbolize_keys
  end

  def perform(product_id)
    capybara_setup
    product = Product.find(product_id)
    visit product.url
    settings = parse_options(product.site, product)
    product.parsed = true
    product.save if product.changed?
    settings
  end
end
