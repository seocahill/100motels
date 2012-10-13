class LocationsController < ApplicationController

  def index
    if params[:search].present?
      @locations = Location.near(params[:search], 300, order: :distance)
    else
    @locations = Location.all
    end
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "Rock and Roll"
      redirect_to @location
    else
      flash[:alert] = "location has not been created"
      render :action => "new"
    end
  end

  def show
    @location = Location.find(params[:id])
  end
end