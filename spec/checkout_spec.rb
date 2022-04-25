require 'spec_helper'
require_relative '../lib/item'
require_relative '../lib/product_storage'
require_relative '../lib/checkout'
require_relative '../lib/rules/bogof_rule'
require_relative '../lib/rules/bulk_discount'

RSpec.describe Checkout do
  let(:strawberry) { Item.new(name: 'strawberries', code: 'SR1', price: 5) }
  let(:coffee) { Item.new(name: 'coffee', code: 'CF1', price: 11.23) }
  let(:fruit) { Item.new(name: 'fruit tea', code: 'FR1', price: 3.11) }

  it 'can scan a fruit tea item' do
    co = described_class.new
    co.scan(fruit.code)

    expect(co.total).to eq(3.11)
  end

  it 'can scan a strawberry item' do
    co = described_class.new
    co.scan(strawberry.code)

    expect(co.total).to eq(5.00)
  end

  it 'can scan a coffee item' do
    co = described_class.new
    co.scan(coffee.code)

    expect(co.total).to eq(11.23)
  end

  it 'calculates the total price of items in the basket, without pricing rules' do
    co = described_class.new
    co.scan(fruit.code)
    co.scan(fruit.code)

    expect(co.total).to eq(6.22)
  end

  context 'when the discount rule is BOGOF' do
    context 'and there are 2 or more fruit teas' do
      it 'applies the offer to fruit tea' do
        princing_rules = [BogofRule]

        co = described_class.new(princing_rules)
        co.scan(fruit.code)
        co.scan(fruit.code)

        expect(co.total).to eq(3.11)
      end
    end
  end

  context 'when the discount rule is bulk_discount' do
    context 'and there are 3 or more strawberries' do
      it 'applies the offer to strawberry items' do
        princing_rules = [BulkDiscount]

        co = described_class.new(princing_rules)
        co.scan("SR1")
        co.scan("SR1")
        co.scan("SR1")

        expect(co.total).to eq(13.5)
      end
    end
  end

  context 'test data' do
    let(:checkout) do
      princing_rules = [BogofRule, BulkDiscount]
      described_class.new(princing_rules)
    end

    it 'case1' do
      checkout.scan("FR1")
      checkout.scan("SR1")
      checkout.scan("FR1")
      checkout.scan("FR1")
      checkout.scan("CF1")

      expect(checkout.total).to eq(22.45)
    end

    it 'case2' do
      checkout.scan("FR1")
      checkout.scan("FR1")

      expect(checkout.total).to eq(3.11)
    end

    it 'case3' do
      checkout.scan("SR1")
      checkout.scan("SR1")
      checkout.scan("FR1")
      checkout.scan("SR1")

      expect(checkout.total).to eq(16.61)
    end
  end
end
