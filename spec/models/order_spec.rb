require 'spec_helper'

describe Order do
  it { should have_many(:line_items).dependent(:destroy) }
end
