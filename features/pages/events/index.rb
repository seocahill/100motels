module Pages
  module Events
    class Index < CapybaraPageObject::Page

      path 'events'

      def event_titles
        all('#events .title').collect(&:text)
      end
    end
  end
end
