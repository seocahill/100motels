class Message
  include ActiveAttr::Model

  attribute :subject
  attribute :email
  attribute :content
  attribute :admin_email
  attribute :event_id

  validates :subject, presence: true
  validates :email, presence: true
  validates :content, presence: true, length: { maximum: 300 }

  def send_messages
    if event_id
      event = Event.find(self.event_id)
      event.orders.each { |order| Notifier.group_message(self, order).deliver }
    else
      Notifier.delay.private_message(self)
    end
  end
end