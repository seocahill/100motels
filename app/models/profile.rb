class Profile < ActiveRecord::Base

  attr_accessible :promoter_name, :visible, :image, :available, :fee, :quick_profile,
                  :about, :equipment, :venues, :travel, :accomodation, :support, :promoter_media
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']
  enum_accessor :state, [ :provisional, :verified, :suspended ]

  belongs_to :user
  # belongs_to :location

  auto_html_for :promoter_media do
    html_escape
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
end
