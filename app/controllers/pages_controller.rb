class PagesController < ApplicationController
  # layout 'landing', only: [:index]

  def home
  end

  def info
  end

  def index
    @event = Event.new
  end
end
