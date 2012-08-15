module Pages
  module Events
    class Index < CapybaraPageObject::Page

      path 'events'

      # component :navigation { Components::Navigation.new find('#nav') }
      # component :event_list { Components::EventList.new find('#events') }

      def event_titles
        all('#events .title').collect(&:text)
      end
    end
  end
end

# module Components
#   class EventList < CapybaraPageObject::Component
#     def titles
      
#     end
#   end
# end