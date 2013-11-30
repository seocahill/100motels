class DeferService
  def initialize(event, message)
    @event = event
    @message = message
  end

  def process_deferral
    OrderMailer.delay.event_deferred(@event.id, @message)
    @event.date = @message.date
    @event.save(validate: false)
  end
end