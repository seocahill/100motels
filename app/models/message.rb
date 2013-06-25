class Message
  include ActiveAttr::Model

  attr_accessor :subject, :email, :content, :organizer_email

  validates :subject, presence: true
  validates :email, presence: true
  validates :content, presence: true, length: { maximum: 300 }
end