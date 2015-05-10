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
      about_text = "#Read this first!\n-----\n\n###This page uses redcarpet markdown!\n\n####Markdown is a special shorthand for quickly formatting text. Click the edit button to see what it looks like.\n\n####[Here's](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) a link to a full cheat-sheet for reference.\n\n###Responsive images\n
      \nhttp://jasobrecht.com/wp-content/uploads/2011/03/Grateful-Dead-patch.jpg\n\n###Embed video (also responsive), first youtube\n\nhttp://www.youtube.com/watch?v=AQ_6sGiglm4\n\n###Here's a vimeo\n
      \nhttp://vimeo.com/57855999\n\n###Maps work too\n\nhttps://maps.google.com/maps?q=irish+times&hl=en&ll=37.79483,-122.395914&spn=0.011411,0.019913&sll=37.793694,-122.395828&sspn=0.011412,0.019913&t=h&radius=0.65&hq=irish+times&z=16\n\n###And soundclouds...\n\nhttps://soundcloud.com/creteboom/encomium15\n"
      self.events.create(name: "Guest User", date: 3.months.from_now, ticket_price: 10, location: "TBC Dublin, Ireland", about: "hello world", time: Time.now)
    end
  end

  def move_to(user)
    self.events.update_all(user_id: user.id)
    confirm(user)
  end

  def confirm(user)
    user.generate_token(:confirmation_token)
    user.confirmation_sent_at = Time.zone.now
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
