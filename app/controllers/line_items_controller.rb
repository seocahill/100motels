class LineItemsController < ApplicationController

  def new
  end

  def create
    @cart = current_cart

    event = Event.find(params[:line_item][:event_id])
    quantity = params[:line_item][:quantity]
    @line_item = @cart.add_event(event.id, quantity)

    if @line_item.save
      redirect_to(:back)
    else
      redirect_to(:back, notice: "something went wrong")
    end

  end

end
