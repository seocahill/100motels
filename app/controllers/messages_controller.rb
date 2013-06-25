class MessagesController < ApplicationController

  def create
    @message = Message.new(params[:message])
    if @message.valid?
      @message.send_messages
      flash[:notice] = "Message sent!"
    else
      flash[:error] = "Message not sent"
    end
    redirect_to :back
  end
end