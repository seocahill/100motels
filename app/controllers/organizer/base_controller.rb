class Organizer::BaseController < ApplicationController
  before_filter :authorize_admin!
end