require_relative 'item'

class ProductStorage
  def initialize
    @products = [
      Item.new(name: 'strawberries', code: 'SR1', price: 5),
      Item.new(name: 'coffee', code: 'CF1', price: 11.23),
      Item.new(name: 'fruit tea', code: 'FR1', price: 3.11),
    ]
  end

  def find(product_code)
    @products.find { |product| product.code == product_code }
  end
end
