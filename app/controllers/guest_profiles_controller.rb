class GuestProfilesController < ApplicationController
  def create
    user = User.create! { |u| u.profile = GuestProfile.create! }
    cookies[:auth_token] = user.auth_token
    @event = create_starter_event(user)
    redirect_to event_path(@event.id), notice: "Welcome to your event, you can save this account at any time,
     click on 'save account' in the top menu"
  end

private
  def create_starter_event(user)
    event = user.events.new
    event.artist = "Title for your Event"
    event.venue = "A Dungeon or Speak hopefully"
    event.date = 1.month.from_now
    event.ticket_price = 15.0
    event.promoter_id = user.id
    event.save!
    event
  end
end
