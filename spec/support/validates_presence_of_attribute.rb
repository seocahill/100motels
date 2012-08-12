module ValidatesPresecenceOfAttribute
  class Matcher

    def initialize(attribute)
      @attribute = attribute
    end
      
    def matches?(model)
      model.valid?
      model.errors.has_key?(@attribute)
    end
  end

  def validates_presence_of_attribute(attribute)
    Matcher.new(attribute)
  end
end

Rspec.configure do |config|
  config.include ValidatesPresecenceOfAttribute, type: :model
end
