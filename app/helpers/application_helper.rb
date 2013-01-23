module ApplicationHelper

	def title(artist, venue, date)
		if content_for :title
			content_for :title do
				"100 Motels - " + artist + " plays " + venue + ", " + date.strftime("%d/%m/%Y")
			end
    else
      "100 Motels"
		end
	end
end
