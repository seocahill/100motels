module ApplicationHelper

	def title(event)
		if content_for :title
			content_for :title do
				"Get Tickets for " + event.artist + " in " + event.location.city + ", " + event.date.strftime("%d/%m/%Y")
			end
    else
      "100 Motels"
		end
	end
end
