require 'spec_helper'

describe Cart do
  it { should have_many(:line_items).dependent(:destroy) }

  it 'adds line_item to cart'

  context 'new line_item'

    it 'has quantity of one'

  context 'existing line_item'
    
    it 'increases the quantity'

  context 'total price'

    it 'calculates total price of cart correctly'
end