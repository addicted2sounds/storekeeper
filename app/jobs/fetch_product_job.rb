WebMock.allow_net_connect! unless Rails.env.test?
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
    value = page.find(option.selector_type.to_sym, option.selector).native.text
    value.gsub!(/^\302\240|\302\240$/, '')
    value.strip
  end

  def parse_options(site, product)
    site.product_options.map do |option|
      begin
        value = parse_option(option)
        property = ProductProperty.find_or_create_by product_option: option,
                                                     product: product
        property.update name: option.name, parsed_value: value
        [option.name, value]
      rescue Capybara::ElementNotFound
        [option.name, nil]
      end
    end.to_h.symbolize_keys
  end

  def perform(product_id)
    capybara_setup
    product = Product.find(product_id)
    visit product.url
    settings = parse_options(product.site, product)
    product.update_attribute :parsed, true
    settings
  end
end
