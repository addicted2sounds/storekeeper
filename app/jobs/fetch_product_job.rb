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
  end

  def capybara_setup
    capybara_register_driver
    Capybara.configure do |config|
      config.run_server = false
      config.default_driver = :mechanize
    end
  end

  def parse_options(site)
    site.product_options.map do |option|
      begin
        value = page.find(option.selector_type.to_sym, option.selector).text
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
    parse_options(product.site)
  end
end
