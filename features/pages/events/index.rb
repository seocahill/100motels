module Pages
  module Events
    class Index < Pages::Base

      path 'events'

      def event_titles
        all('#events .title').collect(&:text)
      end
    end

    def add_event(title)
      header = find('.title', :text => title)
      entry = header.find(:xpath, '..') # TODO why doesn't parent work here?
      entry.click_button 'Add to Cart'
    end

  end
end
