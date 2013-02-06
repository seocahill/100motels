module Api
  module V1
    class EventsController < ApiController
      # doorkeeper_for :all


      def index
        @events = current_user.events
      end

      def show
        @event = Event.find(params[:id])
      end

      def create
        Event.create(params[:event])
      end

      def update
        current_user.events.update(params[:id], params[:event])
      end

      def destroy
        Event.destroy(params[:id])
      end
    end
  end
end