require_relative 'product_storage'

class Checkout
  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
    @basket = []
    @products = ProductStorage.new
  end

  def scan(product_code)
    product = @products.find(product_code)

    if product
      @basket << product
    end
  end

  def total
    total = @basket.sum(&:price)

    @pricing_rules.each do |rule|
      rule = rule.new(@basket)

      if rule.eligible?
        total -= rule.discount
      end
    end

    total
  end
end
