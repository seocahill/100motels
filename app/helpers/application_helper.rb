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
end
