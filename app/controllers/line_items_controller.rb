class LineItemsController < ApplicationController

  def new
  end

  def create
    @cart = current_cart
    event = Event.find(params[:event_id])
    @line_item = @cart.add_event(event.id)
    
    if @line_item.save
      redirect_to(:back)
    else
      render :action => "new" 
    end
    
  end

end
