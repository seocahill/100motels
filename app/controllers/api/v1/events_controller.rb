module Api
  module V1
    class EventsController < ApiController
      doorkeeper_for :all


      def index
        @events = Event.where("profile_id = ?", current_user.profile.id)
      end

      def show
        @event = Event.find(params[:id])
        # @line_item = LineItem.find(params[:id])
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