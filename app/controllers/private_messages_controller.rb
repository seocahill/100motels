class PrivateMessagesController < ApplicationController

  def create
    @private_message = PrivateMessage.new(params[:private_message])
    if @private_message.valid?
      Notifier.private_message(@private_message).deliver
      flash[:notice] = "Message sent to Organizer"
    else
      flash[:error] = "Message not sent"
    end
    redirect_to :back
  end
end