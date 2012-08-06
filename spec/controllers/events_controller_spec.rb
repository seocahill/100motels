require 'spec_helper'

  describe EventsController do
    it "displays an error message for a missing event" do
    get :show, :id => 'not here'
    response.should redirect_to(events_path)
    message = "The event you were looking for could not be found"
    flash[:alert].should eql(message)
  end
end
