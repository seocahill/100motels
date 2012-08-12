module ValidatesPresenceOf
  class Matcher

    def initialize(attribute)
      @attribute = attribute
    end
      
    def matches?(model)
      model.valid?
      model.errors.has_key?(@attribute)
    end
  end

  def validates_presence_of(attribute)
    Matcher.new(attribute)
  end
end

RSpec.configure do |config|
  config.include ValidatesPresenceOf, type: :model
end
