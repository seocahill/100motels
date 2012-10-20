# class RegistrationsController < Devise::RegistrationsController
#   def new
#     @user = User.new
#     @location = current_user.build_location
#   end

#   def create
#     super
#   end

#   def edit
#     @user = current_user
#     unless current_user.location
#       @location = current_user.build_location
#     end
#   end

#   def update
#     super
#   end
# end