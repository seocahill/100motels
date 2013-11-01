class Admin::TicketsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @tickets = Ticket.where(order_id: @event.orders.pluck(:id))
  end
end