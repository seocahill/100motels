class Message
  include ActiveModel::Model

  attr_accessor :date, :message, :option

  validates :message, presence: true
  validates :date, presence: true, if: :deferring?
end

def deferring?
  option == "Defer"
end