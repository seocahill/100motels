class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :promoter_name, :visible, :image, :available, :fee, :quick_profile,
                  :about, :equipment, :venues, :travel, :accomodation, :support
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']
  enum_accessor :state, [ :provisional, :verified, :suspended ]
end
