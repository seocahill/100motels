class Profile < ActiveRecord::Base

  attr_accessible :organizer_name, :visible, :image, :available, :fee, :quick_profile,
                  :about, :equipment, :venues, :travel, :accomodation, :support, :organizer_media, :location_id, :new_location
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']
  attr_accessor :new_location
  enum_accessor :state, [ :provisional, :verified, :suspended ]
  before_save :create_location

  has_many :events
  belongs_to :user
  belongs_to :location
  scope :organizer_city, proc { |city| joins(:location).where("city = ?", city) }

  def create_location
    self.location = Location.create(address: new_location) if new_location.present?
  end

  scope :count_events,
    select("profiles.id, count(events.id) AS events_count").
    joins(:events).
    group("profiles.id").
    order("events_count DESC")

  auto_html_for :organizer_media do
    html_escape
    image
    flickr
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
end
