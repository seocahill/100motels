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

	def new_or_view_event
		if current_user && current_user.guest? && current_user.events.present?
			link_to "View Event", event_path(current_user.events.first), class: 'btn btn-large btn-success', id: 'try-it-button'
		elsif current_user
			link_to "View Events", events_path, class: 'btn btn-large btn-success', id: 'try-it-button'
		else
			link_to "Try it free", guest_profiles_path, method: :post, class: 'btn btn-large btn-success', id: 'try-it-button'
		end
	end
end
