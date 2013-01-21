class LocationsController < ApplicationController

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "Location Saved"
      redirect_to @location
    else
      flash[:alert] = "location has not been created"
      render :action => "new"
    end
  end

end