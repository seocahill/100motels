module Pages
  class Home < CapybaraPageObject::Page

    path '/'

    def event_titles
      all('#events .title').collect(&:text)
    end

    def promoter_names
      all('#promoter .name').collect(&:text)
    end
  end
end
