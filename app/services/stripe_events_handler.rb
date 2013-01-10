class StripeEventsHandler

  def initialize(event)
    @stripe_event = event
  end

  def case_statement
   # figure out which event it is then call a method to handle it
  end
end