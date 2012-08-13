require 'spec_helper'

describe Cart do
  it { should have_many(:line_items).dependent(:destroy) }
end
