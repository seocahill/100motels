class PagesController < ApplicationController
  layout 'landing', only: [:index]

  def info
    expires_in 5.minutes, public: true
  end

  def index
    @event = Event.new
    expires_in 5.minutes, public: true
  end
end
