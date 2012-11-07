class Profile < ActiveRecord::Base

  attr_accessible :promoter_name, :visible, :image, :available, :fee, :quick_profile,
                  :about, :equipment, :venues, :travel, :accomodation, :support, :promoter_media
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']
  enum_accessor :state, [ :provisional, :verified, :suspended ]

  has_many :events
  belongs_to :user

  scope :count_events,
    select("profiles.id, count(events.id) AS events_count").
    joins(:events).
    group("profiles.id").
    order("events_count DESC")

  auto_html_for :promoter_media do
    html_escape
    flickr
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
end
