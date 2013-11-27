class User < ActiveRecord::Base
  enum_accessor :state, [ :unconfirmed, :normal, :suspended, :superadmin]
  has_many :events
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
      about_text = <<-END
        #Read this first!\n\n---\n\n
        ###You can edit this page by clicking on any element that is marked with an  icon. All your changes should be saved automatically.\n\n
        ####This page uses redcarpet markdown for formating, you can also embed media objects and images.\n\n
        ####Don't forget to mention the lineup for the night:\n1. [Crete Boom](http://creteboom.com/).\n
        2. [Another Band](http://example.com/).\n\n> fuckin A\n\n####Here's some Crete Boom vids, first youtube:\n\n
        http://www.youtube.com/watch?v=AQ_6sGiglm4\n\nthen vimeo (try resizing the browser all embeds should be responsive)\n\n
        http://vimeo.com/57855999\n\n####Here's a map for the venue\n\n
        https://maps.google.com/maps?q=irish+times&hl=en&ll=37.79483,-122.395914&spn=0.011411,0.019913&sll=37.793694,
        -122.395828&sspn=0.011412,0.019913&t=h&radius=0.65&hq=irish+times&z=16
        END
      self.events.create(name: "Example Show", date: 3.months.from_now, ticket_price: 10, location: "Dublin, Ireland", about: about_text)
    end
  end

  def move_to(user)
    self.events.update_all(user_id: user.id)
    user.confirm!
  end

  def confirm!
    self.generate_token(:confirmation_token)
    self.confirmation_sent_at = Time.zone.now
    save!
    UserMailer.delay.email_confirmation(self.id)
  end

  def connect(auth)
    self.stripe_uid = auth.uid
    self.api_key = auth.credentials["token"]
    save!
  end


  def send_password_reset
    self.generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.delay.password_reset(self.id)
  end
end
