require 'capybara/dsl'
require 'mechanize_parser'

class FetchProductJob < ActiveJob::Base
  queue_as :parser
  include Capybara::DSL
  include MechanizeParser

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

  def parse_product(product)
    visit product.url
    settings = parse_options(product.site, product)
    product.parsed = true
    product.save!
    settings
  rescue
    product.update_attributes parsed: true, error: true
    nil
  end

  def perform(product_id)
    capybara_setup
    product = Product.find(product_id)
    parse_product product
  end
end
