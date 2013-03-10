class GuestProfilesController < ApplicationController
  def create
    user = (current_user.present? && current_user) || User.create! { |u| u.profile = GuestProfile.create! }
    cookies[:auth_token] = user.auth_token
    @event = create_starter_event(user)
    redirect_to event_path(@event.id), notice: "Welcome to your event, you can save this account at any time,
     click on 'save account' in the top menu"
  end

private
  def create_starter_event(user)
    location = request.location.present? ? request.location.address : "Dublin, Ireland."
    event = Event.new
    event.event_users.build(user_id: user.id, state: :event_admin)
    event.build_location(address: location)
    event.title = "A Title for your show"
    event.artist = "Tell me who's performing..."
    event.venue = "The Nightclub"
    event.date = 1.month.from_now
    event.doors = Time.now.midnight
    event.ticket_price = 15.0
    event.target = 100
    event.capacity = 200
    event.save!
    event
  end
end
