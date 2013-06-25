class PagesController < ApplicationController
  layout 'landing', only: [:index]

  def info
  end

  def index
    @event = Event.new
  end

private
  def determine_layout
    current_user ? "application" : "landing"
  end
end
