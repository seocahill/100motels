module Pages
  module Events
    class Index < Pages::Base

      path 'events'

      def event_titles
        all('#events .title').collect(&:text)
      end
    end
  end
end
