module Api
  module V1
    class EventsController < ApplicationController
      http_basic_authenticate_with name: "doorkeeper", password: "ghostbusters"
      respond_to :json

      def index
        respond_with Event.all
      end

      def show
        respond_with Event.find(params[:id])
      end

      def create
        respond_with Event.create(params[:event])
      end

      def update
        respond_with Event.update(params[:id], params[:event])
      end

      def destroy
        respond_with Event.destroy(params[:id])
      end
    end
  end
end