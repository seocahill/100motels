class PagesController < ApplicationController
  layout :determine_layout, only: [:index]

  def home
  end

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
