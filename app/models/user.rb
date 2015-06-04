class User < ActiveRecord::Base
  enum state: [ :unconfirmed, :normal, :suspended, :superadmin]
  has_many :events
  has_many :orders, through: :events
  before_create :generate_token
  validates_presence_of :name, :email, unless: :guest?
  validates_uniqueness_of :email, allow_blank: true
  has_secure_password validations: false

  def generate_token(column=:auth_token)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while self.class.exists?(column => self[column])
  end

  def self.new_guest
    new { |u| u.guest = true }
  end

  def guest_user_event
    if self.guest?
      image = "https://www.filepicker.io/api/file/2vRXfjobR2WO6Ck1zKkI"
      about_text = "# Welcome to your event!\n\n---\n\nhttps://soundcloud.com/seo-cahill/sets/guitar\n\n---\n\n### About the band\n\nRobert Hunter and Alan Trist, who carefully shepherd the Grateful Dead’s publishing company, Ice Nine, have been quite picky through the years about which film and TV projects they will allow the Dead’s music to appear in. \n\nYou just know that there must be an avalanche of requests to use “Truckin’” and “Uncle John’s Band” and other tunes, but by being so selective, they have helped maintain the integrity of their song catalog. It’s not just a question of “selling out,” because I don’t think anyone begrudges songwriters an opportunity to make money from their labors. \n\nBut it is understanding how a song is going to be used and deciding if that context is appropriate for the song in question. For years, Pete Townshend has sold Who songs to seemingly any company that will put up some cash, and in the process he’s cheapened many of his classics in my eyes. \n\nThe Buffalo Springfield song “For What’s It’s Worth” (“Stop, children what’s that sound…”) seems to be in every film and TV show set in the 1960s no matter what the quality, and as a result Stephen Stills’ great tune has become a boring film music cliché.\n\n\n[More great music here](http://www.markitdown.net/)\n\n---\n\nhttps://www.youtube.com/watch?v=F0sipEKhIhc\n\n---\n\n### Venue: The Liffey Beat club.\n\nRed light in the skylight. Ring to enter.\n\n---\n\nhttps://maps.google.com/maps?q=irish+times&hl=en&ll=37.79483,-122.395914&spn=0.011411,0.019913&sll=37.793694,-122.395828&sspn=0.011412,0.019913&t=h&radius=0.65&hq=irish+times&z=16\n\n---\n"
      self.events.create(name: "Unsaved Event", date: 3.months.from_now, ticket_price: 10, location: "TBC Dublin, Ireland", about: about_text, time: Time.now, image: image)
    end
  end

  def move_to(user)
    self.events.update_all(user_id: user.id)
    confirm(user)
  end

  def confirm(user)
    user.generate_token(:confirmation_token)
    user.confirmation_sent_at = Time.zone.now
    user.state = "normal"
    user.save
    UserMailer.delay.email_confirmation(user.id)
  end

  def connect(auth)
    self.stripe_uid = auth.uid
    self.api_key = auth.credentials["token"]
    self.stripe_data = auth
    save!
  end

  def send_password_reset
    self.generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.delay.password_reset(self.id)
  end
end
