class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :promoter_name, :visible, :image, :available, :fee, :quick_profile,
                  :about, :equipment, :venues, :travel, :accomodation, :support
end
