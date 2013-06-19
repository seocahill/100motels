class Organizer::BaseController < ApplicationController
  before_filter :user_suspended
end