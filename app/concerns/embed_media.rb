module  EmbedMedia
  extend ActiveSupport::Concern

  module ClassMethods
    auto_html_for :video do
      html_escape
      youtube(:width => 630, :height => 430)
      vimeo(:width => 630, :height => 430)
      link :target => "_blank", :rel => "nofollow"
      simple_format
    end

    auto_html_for :music do
      html_escape
      soundcloud(:width => 630, :height => 200)
      link :target => "_blank", :rel => "nofollow"
      simple_format
    end

    auto_html_for :media do
      html_escape
      youtube(:width => 630, :height => 430)
      vimeo(:width => 630, :height => 430)
      soundcloud(:width => 630, :height => 200)
      link :target => "_blank", :rel => "nofollow"
      simple_format
    end
  end
end