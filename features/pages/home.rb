module Pages
  class Home < CapybaraPageObject::Page

    path '/'

    def event_titles
      all('#events-preview .title').collect(&:text)
    end

    def promoter_names
      all('#promoters-preview .email').collect(&:text)
    end
  end
end
