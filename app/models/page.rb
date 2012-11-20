class Page
  include ActiveAttr::Model

  # def check_locations
  #   locations = Location.near(@location, 30000, order: :distance).joins(:event).where("events.state > 0 and events.state < 3").uniq.limit(6)
  #   events = Event.where("events.state > 0 and events.state < 3").uniq.limit(6)
  #   if locations.length
  #     locations
  #   else
  #     events
  #   end
  # end

end