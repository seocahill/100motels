class Message
  include ActiveModel::Model

  attr_accessor :date, :message, :defer

  validates :date, presence: true, if: :deferring?
end

def deferring?
  defer.present?
end