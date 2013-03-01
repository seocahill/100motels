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

  def update
    @location = Location.find(params[:id])
    @location.update_attributes(params[:location])
    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(events_path, :notice => 'Your Account was successfully updated.') }
        format.json { respond_with_bip(@location) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@location) }
      end
    end
  end
end