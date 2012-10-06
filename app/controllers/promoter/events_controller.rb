class Promoter::EventsController < Promoter::BaseController

  def index
    @events = current_user.events.all(order: "artist")
  end

  def new
    @event = current_user.events.build()
  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

end
