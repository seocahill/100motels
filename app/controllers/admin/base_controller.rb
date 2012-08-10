class Admin::BaseController < ApplicationController
  before_filter :authorize_admin!, :except => 'index'

  def index
    
  end

end