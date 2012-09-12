module Api
  module V1
    class EventsController < ApiController
      doorkeeper_for :all
      respond_to :json

      def index
        respond_with current_user.events
      end

      def show
        respond_with Event.find(params[:id])
      end

      def create
        respond_with Event.create(params[:event])
      end

      def update
        respond_with current_user.events.update(params[:id], params[:event])
      end

      def destroy
        respond_with Event.destroy(params[:id])
      end
    end
  end
end