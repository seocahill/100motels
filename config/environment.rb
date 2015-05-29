# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OneHundredMotels::Application.initialize!


Rails.logger = Le.new('dddc222f-97e2-4e7a-b3d8-620897bd45a7', :debug => true, :local => true)
