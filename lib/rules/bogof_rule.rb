class BogofRule
  def initialize(basket)
    @basket = basket
  end

  def eligible?
    !! eligible_item && count_eligible_item >= 2
  end

  def discount
    (count_eligible_item / 2) * eligible_item.price
  end

  private

    def eligible_item
      @basket.find { |item| item.code == "FR1" }
    end

    def count_eligible_item
      @basket.count { |item| item.code == "FR1" }
    end
end
