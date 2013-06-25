class MessagesController < ApplicationController

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      Notifier.private_message(@message).deliver
      flash[:notice] = "Message sent to Organizer"
    else
      flash[:error] = "Message not sent"
    end
    redirect_to :back
  end

  def customers
    @message = Message.new(params[:message])
    event = Event.find(params[:id])
    if @message.valid?
      event.orders { |order| Notifier.group_message(@message, order).deliver }
    else
      flash[:error] = "Message not sent"
    end
    redirect_to [:organizer, event], notice: "Message sent to customers"
  end
end