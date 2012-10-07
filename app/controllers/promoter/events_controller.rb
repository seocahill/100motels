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
    @event = Event.find_by_id(params[:id])
    @orders = @event.orders
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

end
