class BulkDiscount
  def initialize(basket)
    @basket = basket
  end

  def eligible?
    !! eligible_item && count_eligible_item >= 3
  end

  def discount
    count_eligible_item * 0.5
  end

  private

    def eligible_item
      @basket.find { |item| item.code == "SR1" }
    end

    def count_eligible_item
      @basket.count { |item| item.code == "SR1" }
    end
end
