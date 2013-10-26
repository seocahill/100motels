class Admin::MessagesController < ApplicationController

  def new
    @message = Message.new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:event_id])
    @message = Message.new(message_params)
    if @message.valid?
      case @message.option
      when "Defer"
        DeferService.new(@event, @message).process_deferral
        redirect_to [:admin, @event], notice: "Event has been deferred"
      when "Cancel"
        CancelService.new(@event, @message).cancel_orders
        redirect_to [:admin, @event], notice: "Event has been cancelled"
      when "Message"
        # send email to customer group
        redirect_to [:admin, @event], notice: "Message Sent to Customers"
      else
        flash[:error] = "Message couldn't be sent for some unknown reason."
        render action: "new"
      end
    else
      flash[:error] = "Must include a new date"
      render :new
    end
  end

  private
    def message_params
      params.require(:message).permit(:date, :message, :option)
    end
end
