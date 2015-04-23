class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :signed_in?
end
