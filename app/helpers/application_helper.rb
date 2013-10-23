module ApplicationHelper

	def title(event)
		if content_for :title
			content_for :title do
				event.name + " in " + event.location + ", " + event.date.strftime("%d/%m/%Y")
			end
    else
      "100 Motels"
		end
	end

  def event_admin(event)
    current_user.events.includes event
  end
end
