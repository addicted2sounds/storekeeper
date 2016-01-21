module ProductsHelper
  def product_option(product, option)
    name = option.name.to_sym
    return product.send(name) if product.respond_to? name
    raw product.option(option).parsed_value
  end
end
