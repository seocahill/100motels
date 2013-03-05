class ChargesWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    process_charge(order) if [:pending, :failed].include? order.stripe_event
  end

  def process_charge(order)
    charge = charge_customer(order)
    if charge.present?
      order.stripe_charge_id = charge[:id]
      if charge[:paid] == true
        order.stripe_event = :paid
        if order.quantity.times {order.tickets.create(event_id: order.event_id)}
          order.stripe_event = :tickets_sent
        end
      else
        order.stripe_event = :failed
      end
    else
    order.stripe_event = :failed
    end
    order.save!
  end

  def charge_customer(order)
    event = Event.find(order.event_id)
    organizer = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first
    total = (order.total * 100).to_i
    fee = (order.quantity * event.ticket_price).to_i
    token = create_charge_token(order, organizer)
    charge = Stripe::Charge.create(
      {
        amount: total,
        currency: "usd",
        card: token["id"],
        description: "Tickets for #{event.artist} in #{event.venue}, #{event.date.strftime('%A, %b %d')}",
        application_fee: fee
      }, organizer.api_key
    )
  rescue Stripe::CardError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
    return nil
  end

  def create_charge_token(order, organizer)
    token = Stripe::Token.create(
      { customer: order.stripe_customer_token },
      organizer.api_key
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating token: #{e.message}"
  end
end