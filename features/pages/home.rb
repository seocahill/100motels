module Pages
  class Home < Pages::Base

    path '/'

    

    def promoter_names
      all('#promoters-preview .email').collect(&:text)
    end
  end
end
